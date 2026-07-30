## Provisioning a new server

Create the extra-files directory:

`mkdir -p /tmp/<host name>/extra-files/etc/ssh`

Generate the host SSH key. Important: this must create a real private key file, not a symlink.

`ssh-keygen -t ed25519 -N "" -f /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519_key -C "<host name>"`

Convert the SSH public key to an age identity:

`nix run nixpkgs#ssh-to-age < /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519_key.pub`

Add the resulting age recipient to .sops.yaml.

Update keys for secrets files.
`nix run nixpkgs#sops updatekeys secrets/secrets.yaml`
(repeat for each sops file)

Check key is working before install

`test -f /tmp/<host-name>/extra-files/etc/ssh/ssh_host_ed25519_key && echo OK`

Pass the generated host key using `--extra-files`.

```
nix run github:nix-community/nixos-anywhere -- \
  --flake github.com:SamIAm789/dotfiles#<host name> \
  --extra-files /tmp/<host name>/extra-files \
  --target-host root@<target host>
```

After installation, verify that the installed system has a real host key:
`ls -l /etc/ssh/ssh_host_ed25519_key`
It should eventually point to the preserved file:
`/etc/ssh/ssh_host_ed25519_key -> /persist/etc/ssh/ssh_host_ed25519_key`
The persisted key should also be a real file:
`ls -l /persist/etc/ssh/ssh_host_ed25519_key`
Expected:
`-rw------- root root ssh_host_ed25519_key`

## Recovery using the installer
Import and mount ZFS:
```
sudo zpool import -R /mnt -N -f rpool

sudo zfs mount rpool/local/root
sudo zfs mount rpool/local/nix
sudo zfs mount rpool/local/persist
```
Then bind system directories:
```
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run /mnt/run
```
Enter:
`nixos-enter --root /mnt`
Before rebooting. Leave the chroot:
`exit`

Remove bind mounts:
```
sudo umount /mnt/dev
sudo umount /mnt/proc
sudo umount /mnt/sys
sudo umount /mnt/run
```
Unmount ZFS:
`sudo zfs unmount -a`
Export the pool:
`sudo zpool export rpool`
