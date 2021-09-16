{ config, pkgs, ... }:
{
  imports = [
    ./client/prometheus.nix
    #./client/loki.nix  ## TODO
  ];
}
