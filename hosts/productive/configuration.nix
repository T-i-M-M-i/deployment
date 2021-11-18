{ config, pkgs, ... }:
{
  imports = [
    ../../modules/hetzner.nix
  ];

  system.stateVersion = "21.11";

  networking = {
    hostName = "productive";
    interfaces.ens3 = {
      ipv6.addresses = [ { address = "2a01:4f8:1c17:e405::1"; prefixLength = 64; } ];
    };
  };
}
