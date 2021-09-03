{ config, pkgs, nixpkgs, ... }:
{
  services.grafana = {
    enable = true;
    port = 2342;
    domain = "grafana.timmi.johannesloetzsch.de";
  };
}
