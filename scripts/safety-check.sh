#!/usr/bin/env python3
import sys
import json
import re

DANGEROUS_PATTERNS = [
    (r"\brm\s+-(?:r|f|rf|fr)\s+/(?:\s|$)", "Attempting to delete root filesystem"),
    (r"\brm\s+-(?:r|f|rf|fr)\s+~\/?(?:\s|$)", "Attempting to delete user home directory"),
    (r"\bgit\s+push\s+.*--force(?:-with-lease)?\s+.*(?:main|master)\b", "Force push to main/master branch"),
    (r"\b(?:drop\s+database|truncate\s+table)\b", "Destructive SQL operation detected"),
    (r"\bmkfs\b", "Filesystem format command detected"),
    (r"\bdd\s+if=.*of=/dev/", "Raw disk write command detected"),
    (r":\(\)\s*\{\s*:\s*\|\s*:\s*&\s*\}\s*;\s*:", "Fork bomb detected"),
]

def main():
    try:
        input_data = sys.stdin.read()
        if not input_data.strip():
            print(json.dumps({"decision": "allow"}))
            return

        payload = json.loads(input_data)
        tool_call = payload.get("toolCall", {})
        tool_name = tool_call.get("name", "")
        args = tool_call.get("args", {})

        if tool_name == "run_command":
            cmd = args.get("CommandLine", "")
            for pattern, reason in DANGEROUS_PATTERNS:
                if re.search(pattern, cmd, re.IGNORECASE):
                    print(json.dumps({
                        "decision": "ask",
                        "reason": f"Safety check: {reason} ('{cmd}'). User confirmation required."
                    }))
                    return

        print(json.dumps({"decision": "allow"}))
    except Exception as e:
        # Fallback safely to allow on parse error or ask if needed
        print(json.dumps({"decision": "allow"}))

if __name__ == "__main__":
    main()
