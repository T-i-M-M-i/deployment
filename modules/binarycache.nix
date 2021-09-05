{ config, pkgs, ... }:

{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";  ## generated as described in https://nixos.wiki/wiki/Binary_Cache#1._Generating_a_private.2Fpublic_keypair
  };
}
