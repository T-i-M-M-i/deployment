{ config, pkgs, ... }:
{
  imports = [
    ./client.nix
    ./client/loki.nix  ## TODO @client
    ./server/grafana.nix
  ];
}
