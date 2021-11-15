## Deploy

To deploy configuration changes on all timmi servers, as a developer with a deploy key, call:

```shell
nix run
```

## Bootstrap

To setup a new server:
1. boot a nixos image
2. mount the future / to /mnt
3. copy this repo to /mnt/etc/nixos
4. check flake.nix and hosts/$HOSTNAME/\*configuration.nix
  - set a correct static ipv6
5. nixos-install:

```shell
nix-shell -p nixUnstable --command "nixos-install --no-root-passwd --flake .#${HOSTNAME}"
```
