{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../../nginx/grafana.nix
  ];

  services.grafana = {
    enable = true;
    port = 2342;
    domain = "grafana.${config.networking.domain}";
  };
}
