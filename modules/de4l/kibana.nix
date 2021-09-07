{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.elasticsearch = {
    enable = true;
  };

  services.kibana = {
    enable = true;
  };
}
