{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../../nginx/loki.nix
  ];
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };
}
