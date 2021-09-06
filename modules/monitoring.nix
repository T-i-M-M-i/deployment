{ config, pkgs, ... }:

{
  imports = [
    ./monitoring/prometheus.nix
    ./monitoring/loki.nix
    ./monitoring/grafana.nix
  ];
}
