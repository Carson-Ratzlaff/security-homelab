# Ansible

Playbooks I use to build the Elastic side of the lab. They are written to be
re-runnable: each major step checks current state before changing anything.

| File | What it does |
|---|---|
| `install-elastic.yml` | Installs Elasticsearch and Kibana from the Elastic 9.x apt repo, sets the `elastic` password, enrolls Kibana, and generates the Kibana encryption keys that Fleet needs |
| `install-elastic-agent.yml` | Downloads a checksum-pinned Elastic Agent build and enrolls the host in Fleet |
| `inventory.example.yml` | Example inventory using documentation-range addresses |

## Requirements

- `ansible-core` on the control node, SSH key access to the targets, and `sudo` on the targets
- Debian/Ubuntu targets for the Elastic install (it uses `apt`)
- `python3-pexpect` on the Elasticsearch/Kibana host (the `expect` module needs it)
- Elastic Agent playbook: Linux x86_64 targets

## Usage

```bash
cp inventory.example.yml inventory.yml   # inventory.yml is gitignored; edit it
ansible-playbook -i inventory.yml install-elastic.yml
ansible-playbook -i inventory.yml install-elastic-agent.yml
```

Both playbooks prompt for their secret (the new `elastic` password, and the
Fleet enrollment token) instead of reading it from a file.

## Secrets handling

- SSH keys are never stored in this repo. Ansible uses keys from `~/.ssh` / `ssh-agent`.
- Passwords and tokens are entered at run time with `vars_prompt` (`private: true`) and tasks that touch them use `no_log`.
- The real inventory is gitignored; only `inventory.example.yml` is published.
- Planned: move to Ansible Vault or SOPS + age so runs can be non-interactive.

## Known limitations

- The final task of `install-elastic.yml` reboots the host rather than restarting a service.
- `install-elastic-agent.yml` uses `--insecure` (self-signed lab certificate). See the comment in the playbook for the production alternative.
- Not yet covered: n8n, Velociraptor, and hardening roles.
