# cloud-init

First-boot configuration baked into my VM templates so clones can be resized
without manual partitioning.

## Disk layout

Each template uses separate virtual disks, identified by serial number:

| Serial | Mount | Template size | Notes |
|---|---|---|---|
| `boot01` | `/boot` | 2 GB | small, fixed |
| `root01` | `/` | 10 GB | fixed |
| `var01` | `/var` | 5 GB | grown per clone |
| `home01` | `/home` | 5 GB | grown per clone |

Separate disks make it easy to give a log-heavy VM a larger `/var` without
touching the root disk.

## Files

- `cloud-config.yml`: grows partitions and the root filesystem, then runs the script below
- `grow-extra-disks.sh`: finds `var01` / `home01` by `/dev/disk/by-id` and runs `resize2fs` on them

## Usage

1. Build the template with `proxmox/create-template.sh`.
2. Install the cloud-config in the template (for example under `/etc/cloud/cloud.cfg.d/`) and copy the script to `/usr/local/sbin/grow-extra-disks.sh`.
3. Clean cloud-init state and shut down: `sudo cloud-init clean -c all && sudo shutdown now`.
4. Convert to a template, clone, resize the data disks in Proxmox, and boot.
