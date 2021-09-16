{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/nix-deploy-git.nix
  ];

  system.stateVersion = "21.11"; # Did you read the comment?

  networking.hostName = "timmi-staging";

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    nix-index
    vim tmux
    wget curl
    htop atop iotop iftop
    file bc
    git
    bind.dnsutils
  ];

  environment.variables = { EDITOR = "vim"; };
}
