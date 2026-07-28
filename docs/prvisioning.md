## Provisioning a new server

### Generate host ssh and age keys

`mkdir -p /tmp/<host name>/extra-files/etc/ssh

`ssh-keygen -t ed25519 -N "" -f /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519.key -C "<host name>"

`nix run nixpkgs#ssh-to-age < /tmp/<host name>/extra-files/etc/ssh/ssh_host_ed25519_key.pub`

### Add age ket to sops

Create a new host in .sops.yaml.
Update keys for secrets files.
`nix run nixpkgs#sops updatekets secrets/secrets.yaml`
(repeat for each sops file)

### Pass the ssh and age keys using the extra-files function in nixos-anywhere

```
nix run github:nix-community/nixos-anywhere -- \
  --flake .#backup \
  --extra-files /home/sam/backup-server/extra-files \
  --target-host root@100.100.0.5
```
