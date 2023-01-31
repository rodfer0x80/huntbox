#!/bin/sh

VSTATUS=$(LC_ALL=C lscpu | grep Virtualization)
KVMSTATUS=$(zgrep CONFIG_KVM /proc/config.gz)
KVMSTATUS_DEFAULT=$(cat $PWD/config.gz.def)
if [[ -z "$VSTATUS" ]]; then
    echo "[x] Virtualisation is disabled"
    exit 1
fi

if [[ "$KVMSTATUS" != "$KVMSTATUS_DEFAULT" ]]; then
    echo "[x] Kernel not supporting virtualisation"
    exit 2
fi

sudo pacman -Syyu virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat

sudo systemctl start libvirtd.service
sudo cat "$PWD/libvirtd.conf.def" > /etc/libvirt/libvirtd.conf
sudo systemctl restart libvirtd.service
