# <Technique name> (ATT&CK <Txxxx[.xxx]>)

**Date:** YYYY-MM-DD  
**Environment:** <hosts involved, OS versions, sensors/agents enabled>  
**Tools:** <Atomic Red Team test ID / Caldera ability / manual commands>

## Goal

What behavior am I trying to detect, and why does it matter?

## Test

Exactly what I ran, on which host, and as which user. Include commands in a
code block so the test is repeatable.

## Expected telemetry

What I expected to see before running it (log sources, event IDs, Zeek logs,
Suricata signatures).

## What I actually saw

- **Detected:** what fired, and where (Security Onion alert, endpoint event, Zeek log)
- **Missed:** what I expected to see but didn't, and why I think so

Include a short excerpt or screenshot of the relevant event (redact IPs,
hostnames, and anything sensitive).

## Detection

The rule I wrote or tuned (link to the file in `../detections/`), and how it
works in a few sentences.

## Validation

Did the rule fire when I re-ran the test? How did I check for false positives
(for example, benign activity on the same hosts)?

## Lessons learned

What this changed about how I monitor or respond. What I would do differently.

## References

Links to the ATT&CK technique page, the test definition, and any docs used.
