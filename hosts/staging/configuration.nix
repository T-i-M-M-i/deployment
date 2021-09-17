{ config, pkgs, ... }:
{
  imports = [
    ../../modules/hetzner.nix
  ];

  system.stateVersion = "21.11";

  networking = {
    hostName = "staging";
    interfaces.ens3 = {
      ipv6.addresses = [ { address = "2a01:4f8:c010:214f::1"; prefixLength = 64; } ];
    };
  };
}
