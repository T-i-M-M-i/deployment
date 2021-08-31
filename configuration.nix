{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/nix.nix
    ./modules/acme.nix
    ./modules/prometheus.nix
    ./modules/jenkins.nix
  ];

  system.stateVersion = "21.11"; # Did you read the comment?

  networking.hostName = "timmi-test";

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    nix-index
    vim tmux
    wget curl
    htop atop iotop iftop
    file bc
    git
  ];

  environment.variables = { EDITOR = "vim"; };
}
