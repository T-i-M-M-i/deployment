{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nix.nix
    ./modules/dns.nix
    ./modules/nginx.nix
    ./modules/binarycache.nix
    ./modules/monitoring.nix
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
    bind.dnsutils
  ];

  environment.variables = { EDITOR = "vim"; };
}
