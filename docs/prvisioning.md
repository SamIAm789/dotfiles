## Provisioning a new server

Create the extra-files directory:

`mkdir -p /tmp/<host name>/extra-files/etc/ssh`

Generate the host SSH key. Important: this must create a real private key file, not a symlink.

`ssh-keygen -t ed25519 -N "" -f /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519_key -C "<host name>"`

Convert the SSH public key to an age identity:

`nix run nixpkgs#ssh-to-age < /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519_key.pub`

Add the resulting age recipient to .sops.yaml.

`cp -L ssh_host_ed25519_key /mnt/persist/etc/ssh/ssh_host_ed25519_key`

Update keys for secrets files.
`nix run nixpkgs#sops updatekets secrets/secrets.yaml`
(repeat for each sops file)

Check key is working before install

`test -f /tmp/<host-name>/extra-files/etc/ssh/ssh_host_ed25519_key && echo OK`

Pass the generated host key using `--extra-files`.

```
nix run github:nix-community/nixos-anywhere -- \
  --flake github.com/SamIAm789/dotfiles#<host name> \
  --extra-files /tmp/<host name>/extra-files \
  --target-host root@<target host>
```

After installation, verify that the installed system has a real host key:
`ls -l /etc/ssh/ssh_host_ed25519_key`
It should be a normal file:
`-rw------- root root ssh_host_ed25519_key`
The persisted key should also be a real file:
`-rw------- root root ssh_host_ed25519_key`

## Recovery using the installer
If using nixos-enter, mount the datasets first:
```
zpool import -R /mnt -N -f rpool

zfs mount rpool/local/root
zfs mount rpool/local/nix
zfs mount rpool/local/persist
```
Then bind system directories:
```
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
mount --bind /run /mnt/run
```
Before rebooting from the installer

Remove bind mounts:
```
umount /mnt/dev
umount /mnt/proc
umount /mnt/sys
umount /mnt/run
```
Unmount ZFS:
`zfs unmount -a`
Export the pool:
`zpool export rpool`
