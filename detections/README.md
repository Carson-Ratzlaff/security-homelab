# Detections

**Status: planned. No rules have been published yet.** This folder will hold
detection content produced by the attack-and-detect cycles described in the
main README. I'm keeping the plan here so it's clear what will land and how it
will be validated.

## Planned workflow

1. Pick an ATT&CK technique and run a test against the instrumented lab range (Atomic Red Team or Caldera).
2. Record what Security Onion (Zeek, Suricata) and the endpoint agents actually saw.
3. Write or tune a rule for anything that was missed.
4. Re-run the test to confirm the rule fires, then check it for false positives.
5. Write up the cycle in [`../writeups/`](../writeups/).

## Planned layout

```
detections/
├── sigma/        # Sigma rules (portable detection logic)
├── suricata/     # Suricata rules, tested against PCAPs
├── yara/         # YARA rules, tested against a clean corpus
└── coverage/     # ATT&CK coverage notes / Navigator layer
```

## Quality bar for anything published here

- Each rule links to the test that triggers it and the write-up that explains it
- Known false positives and tuning notes are documented
- Rules are tested before they are committed
