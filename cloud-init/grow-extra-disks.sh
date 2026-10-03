#!/bin/bash
# Grow the filesystems on the extra data disks after a clone has been resized.
# Disks are located by the serial number set when the template was created
# (see proxmox/create-template.sh), not by device name.

volumes=(var01 home01)

for volume in "${volumes[@]}"; do
    echo "${volume}"
    dev_by_id="/dev/disk/by-id/scsi-SQEMU_QEMU_HARDDISK_${volume}"
    echo "${dev_by_id}"
    if [ -e "${dev_by_id}" ]; then
        resize2fs "${dev_by_id}"
    else
        echo "file does not exist"
    fi
done
