#!/bin/bash
# Creates the empty VM shell for a new Ubuntu template on Proxmox, with the
# separate-disk layout used by cloud-init/. Run on the Proxmox host.
#
# Override defaults with environment variables, for example:
#   STORAGE=local-lvm ./create-template.sh
set -euo pipefail

STORAGE="${STORAGE:-usb-ssd}"
BRIDGE="${BRIDGE:-vmbr0}"
ISO="${ISO:-local:iso/ubuntu-24.04.4-live-server-amd64.iso}"

read -r -p "VMID: " vmid
read -r -p "Name: " name

qm create "${vmid}" \
  --name "${name}" \
  --memory 2048 --cores 2 \
  --net0 "virtio,bridge=${BRIDGE}" \
  --scsihw virtio-scsi-single \
  --ostype l26

qm set "${vmid}" --scsi0 "${STORAGE}:2,serial=boot01"    # /boot: small, fixed
qm set "${vmid}" --scsi1 "${STORAGE}:10,serial=root01"   # /: fixed, won't grow
qm set "${vmid}" --scsi2 "${STORAGE}:5,serial=var01"     # /var: placeholder size
qm set "${vmid}" --scsi4 "${STORAGE}:5,serial=home01"    # /home: placeholder size

qm set "${vmid}" --ide2 "${ISO},media=cdrom"
qm set "${vmid}" --boot order=ide2
qm set "${vmid}" --agent enabled=1

cat << 'NEXT'

Manual steps after installing the OS:
  1. sudo apt install -y qemu-guest-agent && sudo systemctl enable --now qemu-guest-agent
  2. Install the cloud-init config and grow script from ../cloud-init/ (see its README)
  3. sudo cloud-init clean -c all && sudo shutdown now
  4. Convert the VM to a template in Proxmox
NEXT
