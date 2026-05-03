#!/bin/bash

### USER INPUT VARIABLES
read -p '[REQUIRED] CPU TYPE [intel/amd]: ' cpu_type < /dev/tty
if [[ -z $cpu_type ]]; then
  echo "ERROR: CPU TYPE REQUIRED... Exiting"
  exit 1
fi

read -p '[REQUIRED] GPU TYPE [intel/amd/nvidia]: ' gpu_type < /dev/tty
if [[ -z $gpu_type ]]; then
  echo "ERROR: GPU TYPE REQUIRED... Exiting"
  exit 1
fi

lspci -nn | grep -E "VGA|3D|Display"

read -p '[REQUIRED] WHICH GPU DEVICE(S) TO PASSTHROUGH [00:02.0 (COMMA SEPARATED FOR MULTIPLE)]: ' gpu < /dev/tty
if [[ -z $gpu ]]; then
  echo "ERROR: GPU DEVICE REQUIRED... Exiting"
  exit 1
fi

### SCRIPT VARIABLES
GRUB_CMDLINE_LINUX_DEFAULT="quiet ${cpu_type}_iommu=on iommu=pt"

### MAIN SCRIPT
if [[ -f /etc/default/grub ]]; then
  if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub; then
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUB_CMDLINE_LINUX_DEFAULT\"/g" /etc/default/grub
  else
    echo "GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUB_CMDLINE_LINUX_DEFAULT\"" >> /etc/default/grub
  fi
else
  echo "ERROR: /etc/default/grub not found... Exiting"
  exit 1
fi

update-grub

if [[ -f /etc/modules-load.d/vfio.conf ]]; then
  if ! grep -q "vfio" /etc/modules-load.d/vfio.conf; then
    echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" >> /etc/modules-load.d/vfio.conf
  fi
else
  echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" > /etc/modules-load.d/vfio.conf
fi

if [[ $gpu_type == "intel" ]]; then
  echo "blacklist i915" >> /etc/modprobe.d/blacklist.conf
elif [[ $gpu_type == "amd" ]]; then
  echo "blacklist amdgpu" >> /etc/modprobe.d/blacklist.conf
elif [[ $gpu_type == "nvidia" ]]; then
  echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
else
  echo "ERROR: INVALID GPU TYPE... Exiting"
  exit 1
fi

if [[ -f /etc/modprobe.d/vfio.conf ]]; then
  if ! grep -q "options vfio-pci ids=$gpu" /etc/modprobe.d/vfio.conf; then
    echo "options vfio-pci ids=$gpu" >> /etc/modprobe.d/vfio.conf
  fi
else
  echo "options vfio-pci ids=$gpu" > /etc/modprobe.d/vfio.conf
fi

update-initramfs -u

echo "GPU PASSTHROUGH CONFIGURED... REBOOT REQUIRED"