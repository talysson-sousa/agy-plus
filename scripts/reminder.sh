#!/usr/bin/env python3
import json

def main():
    payload = {
        "injectSteps": [
            {
                "ephemeralMessage": "Remember development guidelines: Security First (no hardcoded secrets), Immutability (no mutations), Small Files (<400 lines), and TDD with 80%+ test coverage."
            }
        ]
    }
    print(json.dumps(payload))

if __name__ == "__main__":
    main()
