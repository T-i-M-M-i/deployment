{ config, pkgs, ... }:
{
  imports = [
    ../nginx/kibana.nix
  ];

  nixpkgs.config.allowUnfree = true;

  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch7;
  };

  services.kibana = {
    enable = true;
  };
}
