{ config, pkgs, ... }:
{
  imports = [
    ./client.nix
    ./server/grafana.nix
  ];
}
