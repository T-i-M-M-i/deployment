{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "21.11"; # Did you read the comment?

  networking.hostName = "timmi-test";

  environment.systemPackages = with pkgs; [
    nix-index
    vim tmux
    wget curl
    htop atop iotop iftop
    file bc
    git
  ];

  time.timeZone = "Europe/Berlin";
  environment.variables = { EDITOR = "vim"; };
}

