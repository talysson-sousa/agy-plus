---
name: native-mcp-http-server
description: Padrão arquitetural para implementar servidores Model Context Protocol (MCP) nativos em Node.js/TypeScript sobre HTTP e JSON-RPC 2.0 sem SDKs pesados, expondo ferramentas de backend para agentes de IA (Claude, Antigravity, n8n, LangChain).
---

# Native MCP HTTP Server (Zero-Dependency Pattern)

**Extracted:** 2026-10-05
**Context:** Expõe ferramentas e dados de qualquer backend para Agentes de IA via Model Context Protocol (MCP) usando apenas TypeScript nativo e Node.js `http.createServer`.

## Problem
A biblioteca oficial `@modelcontextprotocol/sdk` introduz 17+ dependências transitivas pesadas (Hono, Express, Ajv, Cors, EventSource, etc.) e o modo tradicional stdio via CLI adiciona grande latência de inicialização em containers Docker. Muitas aplicações precisam apenas expor ferramentas analíticas para agentes de IA através da rede HTTP de forma leve, rápida e com tipagem estrita.

## Solution

1. **Protocolo JSON-RPC 2.0 Tipado (`types.ts`)**:
   - Mensagens com `jsonrpc: "2.0"`, `id`, `method`, `params`.
   - Códigos de erro padrão: `-32600` (Invalid Request), `-32601` (Method not found), `-32602` (Invalid params), `-32603` (Internal error).

2. **Declaração Declarativa de Ferramentas (`tools.ts`)**:
   - Array imutável `MCP_TOOLS` com `name`, `description` e `inputSchema` (JSON Schema).
   - Função executora `executeMcpTool(name, args, context)` retornando `{ content: [{ type: "text", text: string }] }`.

3. **Dispatcher Agnóstico (`dispatcher.ts`)**:
   - Trata os métodos da especificação MCP:
     - `initialize`: Retorna `protocolVersion: "2024-11-05"`, `capabilities: { tools: {} }`, `serverInfo`.
     - `notifications/initialized`: Confirmação de conexão pós-handshake.
     - `ping`: Health check (retorna `{}`).
     - `tools/list`: Lista o catálogo de ferramentas e schemas.
     - `tools/call`: Valida se a ferramenta existe e executa, capturando erros amigavelmente.

4. **Exposição em Rotas HTTP (`server.ts`)**:
   - `GET /mcp`: Retorna manifesto amigável em JSON para autodescoberta e documentação.
   - `POST /mcp`: Recebe requisições JSON-RPC, protegidas por limite de payload (1 MB) contra DoS.

## Code Example

```typescript
// 1. types.ts
export interface JsonRpcRequest {
  readonly jsonrpc: '2.0'
  readonly id?: string | number | null
  readonly method: string
  readonly params?: Record<string, unknown>
}

export interface McpTool {
  readonly name: string
  readonly description: string
  readonly inputSchema: {
    readonly type: 'object'
    readonly properties: Record<string, unknown>
    readonly required?: readonly string[]
  }
}

// 2. dispatcher.ts
export async function handleMcpMessage(rawPayload: unknown, ctx: AppContext) {
  if (!rawPayload || typeof rawPayload !== 'object' || (rawPayload as any).jsonrpc !== '2.0') {
    return { jsonrpc: '2.0', id: null, error: { code: -32600, message: 'Invalid Request' } }
  }
  const req = rawPayload as JsonRpcRequest
  const id = req.id ?? null

  switch (req.method) {
    case 'initialize':
      return {
        jsonrpc: '2.0',
        id,
        result: {
          protocolVersion: '2024-11-05',
          capabilities: { tools: {} },
          serverInfo: { name: 'my-service', version: '1.0.0' }
        }
      }
    case 'tools/list':
      return { jsonrpc: '2.0', id, result: { tools: TOOLS_CATALOG } }
    case 'tools/call':
      const { name, arguments: args } = (req.params ?? {}) as any
      const result = await executeTool(name, args, ctx)
      return { jsonrpc: '2.0', id, result }
    case 'ping':
    case 'notifications/initialized':
      return { jsonrpc: '2.0', id, result: {} }
    default:
      return { jsonrpc: '2.0', id, error: { code: -32601, message: `Method ${req.method} not found` } }
  }
}
```

## When to Use
- Quando quiser habilitar Agentes de IA a consumir APIs internas sem acoplar SDKs pesados.
- Ao construir microsserviços Node.js que devem expor dados via Claude Desktop, Antigravity, Cursor, n8n ou LangChain.
- Quando a comunicação via rede HTTP for preferível a processos CLI locais (ex: Docker).
