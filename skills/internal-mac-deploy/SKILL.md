---
name: internal-mac-deploy
description: >-
  Configura qualquer aplicação para deploy de produção no servidor interno macOS (Mac-811).
  Gera ou ajusta Dockerfile multi-stage com targets específicos (base, dependencies, builder, migration, runner, cli)
  e docker-compose.prod.yml integrado à rede 811-internal e ao PostgreSQL global (postgres-database).
metadata:
  version: 1.0.0
---

# Deploy Interno macOS (Mac-811): Guia de Implementação e Padronização

Este guia capacita agentes e desenvolvedores a configurar qualquer aplicação para rodar no servidor de produção **macOS (`Mac-811`)**, seguindo o padrão corporativo de contêineres e banco compartilhado.

---

## 🏗️ 1. Topologia da Infraestrutura (`Mac-811`)

- **Host**: Servidor macOS (Mac mini / Mac Studio)
- **Usuário**: `sistemas` (`/Users/sistemas`)
- **Diretório dos Aplicativos**: `/Users/sistemas/apps/<nome-do-app>/`
- **Rede Docker Global Compartilhada**: `811-internal` (driver: `bridge`, pré-existente)
- **Banco PostgreSQL Global Compartilhado**:
  - Container: `postgres-database` (PostgreSQL 16)
  - Porta: `5432` (interna na rede `811-internal`)
  - Usuário padrão: `sistemas`
  - Senha padrão: `sistemas`
  - Formato de conexão:
    `postgresql://sistemas:sistemas@postgres-database:5432/<nome_do_banco>`

---

## 🚨 2. Regras de Ouro Inegociáveis

1. **NUNCA Criar Container de Banco de Dados no Compose de Produção**:
   - Ambientes de desenvolvimento (`docker-compose.yml`) frequentemente criam um serviço `db` ou `postgres`.
   - Em produção (`docker-compose.prod.yml`), é **estritamente proibido** subir novos contêineres de PostgreSQL.
   - Toda aplicação que usa Postgres **DEVE** conectar ao container global existente: `postgres-database:5432`.
2. **Rede Externa Obrigatória (`811-internal`)**:
   - Todo serviço do compose de produção deve participar da rede `811-internal` declarada como `external: true`.
3. **Padrão Multi-Stage com Targets Específicos no `Dockerfile`**:
   - O Dockerfile deve separar responsabilidades em alvos bem definidos:
     - `base`: Sistema operacional e pacotes nativos (ex: `openssl`, bibliotecas de fontes/chromium).
     - `dependencies`: Instalação de dependências (`npm ci`, `poetry install`, `pip install`).
     - `builder`: Compilação de código e injeção de variáveis públicas de build.
     - `migration`: Imagem enxuta dedicada unicamente a rodar migrações de banco (`prisma db push`, `alembic upgrade`, etc.).
     - `cli` (opcional): Execução de scripts de manutenção, seed ou comandos administrativos via terminal docker.
     - `runner`: Imagem final ultraleve, com usuário não-root, contendo apenas o estritamente necessário para rodar a aplicação.
4. **Ordem Estrita de Execução**:
   - O serviço `app` deve declarar:
     ```yaml
     depends_on:
       migrate:
         condition: service_completed_successfully
     ```
   - O container `migrate` deve ter `restart: "no"` para não entrar em loop.
5. **Sem Conflito de Portas no Host**:
   - Não mapeie portas no host (`ports: - "3000:3000"`) para aplicações web a menos que haja exigência estrita.
   - Os containers se comunicam via nome de serviço na rede `811-internal` (ex: `http://<nome-do-app>-app:3000`) e o tráfego externo/interno é roteado por túneis (Cloudflare Tunnel) ou reverse proxy.
6. **Segurança e Privilégios**:
   - A imagem final (`runner`) nunca deve executar como `root`. Utilize usuários dedicados (ex: `nextjs:nodejs`, `node`, `appuser`).

---

## 📋 3. Fluxo de Execução Passo a Passo

Ao configurar uma aplicação para o Mac-811, siga rigorosamente as etapas:

### Etapa 1: Diagnóstico da Aplicação
Identifique no projeto existente:
1. **Linguagem & Framework**: Next.js, Node/Express/Nest, Python/FastAPI/Django, Vite/React, etc.
2. **ORM / Banco de Dados**: Prisma, Drizzle, TypeORM, Alembic, Knex, etc.
3. **Dependências Nativas de Sistema**: Ex: `openssl` (necessário para Prisma no Debian slim), `chromium`/`puppeteer`, `python-is-python3`, etc.
4. **Arquivos Estáticos e Diretórios Persistentes**: Onde uploads ou arquivos de usuário são salvos (ex: `public/uploads`, `.data`).
5. **Variáveis de Build vs Runtime**: Variáveis que precisam estar presentes na compilação (ex: `NEXT_PUBLIC_*`) vs variáveis lidas em execução.

### Etapa 2: Adequação do Código da Aplicação
- **Next.js**: No `next.config.js` ou `next.config.ts`, certifique-se de ativar `output: "standalone"`:
  ```typescript
  const nextConfig = {
    output: "standalone",
    // ...
  };
  export default nextConfig;
  ```
- **Prisma**: No `Dockerfile`, certifique-se de copiar a pasta `prisma/` antes de rodar `npm ci` para que o postinstall consiga rodar `prisma generate`.

### Etapa 3: Criação/Ajuste do `Dockerfile`
Crie um `Dockerfile` multi-stage otimizado com alvos específicos.

Veja o modelo completo em [Dockerfile.nextjs](./examples/Dockerfile.nextjs).

#### Estrutura Essencial dos Targets:
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS base
WORKDIR /app
# 1. Dependências nativas
RUN apt-get update && apt-get install -y openssl --no-install-recommends && rm -rf /var/lib/apt-get/lists/*

# 2. Dependências do projeto
FROM base AS dependencies
COPY package.json package-lock.json ./
COPY prisma ./prisma
RUN npm ci

# 3. Builder
FROM dependencies AS builder
ARG NEXT_PUBLIC_EXAMPLE_VAR
ENV NEXT_PUBLIC_EXAMPLE_VAR=$NEXT_PUBLIC_EXAMPLE_VAR
COPY . .
RUN npx prisma generate && npm run build

# 4. Target de Migração
FROM dependencies AS migration
COPY prisma ./prisma
CMD ["npx", "prisma", "db", "push"]

# 5. Target CLI (Opcional - tarefas administrativas / seeds)
FROM dependencies AS cli
COPY prisma ./prisma
RUN npx prisma generate
COPY . .
ENTRYPOINT ["npm", "run"]
CMD ["db:status"]

# 6. Target Runner (Produção)
FROM base AS runner
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

RUN groupadd --system --gid 1001 nodejs \
  && useradd --system --uid 1001 --gid nodejs nextjs

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

RUN mkdir -p public/uploads .data/private-uploads \
  && chown -R nextjs:nodejs public/uploads .data

USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```

> **Adaptação para Outras Tecnologias**:
> - **Node.js (NestJS / Express / Fastify)**: No stage `builder` execute `npm run build`. No `runner`, copie `dist/` e `node_modules` de produção (`npm prune --omit=dev`).
> - **Python (FastAPI / Flask)**: No `base` use `python:3.12-slim`. No `migration`, utilize `CMD ["alembic", "upgrade", "head"]`. No `runner`, use `CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000"]`.

---

### Etapa 4: Criação/Ajuste do `docker-compose.prod.yml`
Crie o arquivo `docker-compose.prod.yml` conectando à rede `811-internal` e apontando para o banco global.

Veja o modelo de referência em [docker-compose.prod.yml](./examples/docker-compose.prod.yml).

#### Padrão Estrutural Obrigatório:
```yaml
name: <nome-do-app>-prod

networks:
  811-internal:
    name: 811-internal
    external: true

services:
  migrate:
    build:
      context: .
      target: migration
    container_name: <nome-do-app>-migrate
    env_file:
      - .env
    environment:
      DATABASE_URL: ${DATABASE_URL:-postgresql://sistemas:sistemas@postgres-database:5432/<nome_do_banco>}
    command: ["npx", "prisma", "db", "push"]
    networks:
      - 811-internal
    restart: "no"

  app:
    build:
      context: .
      target: runner
    container_name: <nome-do-app>-app
    restart: unless-stopped
    env_file:
      - .env
    environment:
      DATABASE_URL: ${DATABASE_URL:-postgresql://sistemas:sistemas@postgres-database:5432/<nome_do_banco>}
      PORT: 3000
      HOSTNAME: 0.0.0.0
    volumes:
      - <nome-do-app>_prod_public_uploads:/app/public/uploads
      - <nome-do-app>_prod_private_uploads:/app/.data/private-uploads
    networks:
      - 811-internal
    depends_on:
      migrate:
        condition: service_completed_successfully

volumes:
  <nome-do-app>_prod_public_uploads:
  <nome-do-app>_prod_private_uploads:
```

---

### Etapa 5: Variáveis de Ambiente de Produção (`.env` / `.env.example`)

Documente ou atualize o `.env.example` com o bloco de variáveis exigido no ambiente do Mac-811:

```env
# ----------------------------------------------------
# BANCO DE DADOS GLOBAL (REDE DOCKER 811-internal)
# ----------------------------------------------------
DATABASE_URL="postgresql://sistemas:sistemas@postgres-database:5432/<nome_do_banco>"

# ----------------------------------------------------
# REDE E PROCESSO INTERNO
# ----------------------------------------------------
PORT=3000
HOSTNAME="0.0.0.0"

# ----------------------------------------------------
# CREDENCIAIS DO BANCO CENTRALIZADO
# ----------------------------------------------------
POSTGRES_DB="<nome_do_banco>"
POSTGRES_USER="sistemas"
POSTGRES_PASSWORD="sistemas"
```

---

### Etapa 6: Validação e Testes Locais da Configuração

Antes de considerar o app pronto para deploy, valide:

1. **Sintaxe do Compose de Produção**:
   ```bash
   docker compose -f docker-compose.prod.yml config
   ```
2. **Build do Target de Migração**:
   ```bash
   docker build --target migration -t <nome-do-app>:migration .
   ```
3. **Build do Target Runner (Aplicação)**:
   ```bash
   docker build --target runner -t <nome-do-app>:runner .
   ```
4. **Verificação de Permissões e Arquivos Sensíveis**:
   - Certifique-se de que o `.dockerignore` inclui `.env`, `.git`, `node_modules` e caches para não inflar as imagens.

---

## 🛠️ 4. Guia Rápido de Troubleshooting

| Sintoma | Causa Raiz | Solução |
| :--- | :--- | :--- |
| `network 811-internal not found` | A rede Docker global ainda não foi criada no host. | Criar no host com `docker network create 811-internal`. |
| `getaddrinfo ENOTFOUND postgres-database` | O container da app não está na rede `811-internal` ou o nome do host do banco está incorreto. | Confirmar que o serviço possui a network `811-internal` e que a URL usa `postgres-database:5432`. |
| `Prisma Client not found / query engine missing` | O stage `runner` não copiou as dependências geradas ou faltou biblioteca nativa. | Instalar `openssl` no stage `base` e verificar o `prisma generate` no builder. |
| `Permission denied /app/public/uploads` | O processo roda como usuário não-root (`nextjs`) sem permissão na pasta de volume. | Executar `chown -R nextjs:nodejs <diretório>` no stage `runner` antes de trocar para `USER nextjs`. |
| `Exit code 0 no container app` ou encerramento imediato | Falha no comando CMD ou falta de processo em primeiro plano. | Garantir que o comando final inicia o servidor ouvindo em `0.0.0.0` (ex: `node server.js`). |
