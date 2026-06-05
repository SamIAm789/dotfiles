# Home Assistant OS VM (Cloud Hypervisor) Documentation

## Overview

This Home Assistant OS (HAOS) instance runs as a Cloud Hypervisor VM on NixOS.

### Architecture

- Hypervisor: Cloud Hypervisor
- Guest: Home Assistant OS
- Disk: `haos.qcow2`
- Firmware: `CLOUDHV.fd`
- Storage: ZFS dataset mounted at `/persist/microvms/haos`
- Networking:
  - TAP interface: `vm-haos`
  - Linux bridge: `microbr`
  - Managed by `systemd-networkd`
- VM service: `haos-vm.service`

---

## Storage Layout

```text
/persist/microvms/haos/
├── haos.qcow2
└── CLOUDHV.fd
```

This directory is backed by a ZFS dataset.

Example:

```bash
zfs list | grep haos
```

---

## Networking

### Host Bridge

The host defines a bridge named:

```text
microbr
```

The physical interface and VM TAP interfaces are attached to this bridge.

### TAP Interface

The HAOS VM uses:

```text
vm-haos
```

Expected state:

```bash
ip link show vm-haos
```

Example:

```text
vm-haos: <NO-CARRIER,BROADCAST,MULTICAST,UP>
master microbr
```

### MAC Address

The VM uses a deterministic MAC address derived from the VM name.

Example:

```text
02:59:f1:9d:db:8c
```

---

## Cloud Hypervisor Configuration

Key runtime parameters:

```text
--firmware /persist/microvms/haos/CLOUDHV.fd
--disk path=/persist/microvms/haos/haos.qcow2,image_type=qcow2
--cpus boot=2
--memory size=4G
--net tap=vm-haos,mac=<generated-mac>
```

---

## Service Management

### Start

```bash
sudo systemctl start haos-vm
```

### Stop

```bash
sudo systemctl stop haos-vm
```

### Restart

```bash
sudo systemctl restart haos-vm
```

### Status

```bash
systemctl status haos-vm
```

### Logs

```bash
journalctl -u haos-vm -f
```

---

## Verification Checklist

### Verify TAP exists

```bash
ip link show vm-haos
```

### Verify bridge membership

```bash
bridge link
```

### Verify service

```bash
systemctl status haos-vm
```

### Verify Home Assistant boot

Look for:

```text
Welcome to Home Assistant
```

in:

```bash
journalctl -u haos-vm -f
```

---

# Migration Guide

## Recommended Method: ZFS Replication

### 1. Stop the VM

```bash
sudo systemctl stop haos-vm
```

### 2. Create a snapshot

Replace the dataset name with the actual pool/dataset path if different.

```bash
sudo zfs snapshot -r pool/persist/microvms/haos@migration
```

### 3. Send to the destination server

```bash
sudo zfs send -R pool/persist/microvms/haos@migration \
  | ssh user@newhost sudo zfs recv -F pool/persist/microvms/haos
```

### 4. Verify files on destination

```bash
ls -lah /persist/microvms/haos
```

Expected:

```text
haos.qcow2
CLOUDHV.fd
```

### 5. Deploy host configuration

Ensure the destination host has:

- Cloud Hypervisor installed
- The HAOS NixOS module enabled
- `microbr` bridge configured
- `systemd-networkd` enabled
- KVM available (`/dev/kvm`)

### 6. Start the VM

```bash
sudo systemctl start haos-vm
```

### 7. Verify operation

```bash
systemctl status haos-vm
journalctl -u haos-vm -f
```

---

## Incremental ZFS Updates

Initial replication:

```bash
zfs snapshot pool/persist/microvms/haos@t0
zfs send -R pool/persist/microvms/haos@t0 \
  | ssh newhost zfs recv -F pool/persist/microvms/haos
```

Later updates:

```bash
zfs snapshot pool/persist/microvms/haos@t1

zfs send -R -i @t0 @t1 \
  | ssh newhost zfs recv -F pool/persist/microvms/haos
```

---

## Troubleshooting

### TAP exists but VM cannot start

Check:

```bash
ip link show vm-haos
```

and

```bash
journalctl -u haos-vm -b
```

### Networking unavailable

Verify:

```bash
ip link show microbr
bridge link
networkctl status vm-haos
```

### KVM unavailable

```bash
ls -l /dev/kvm
```

### Cloud Hypervisor errors

```bash
journalctl -u haos-vm -n 200
```

---

## Recovery Notes

Because the VM state is stored entirely in the ZFS dataset, a migration or backup only requires:

- `haos.qcow2`
- `CLOUDHV.fd`
- Matching NixOS configuration

No additional Home Assistant export/import process is required.
