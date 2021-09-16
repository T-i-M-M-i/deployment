{ config, pkgs, ... }:
{
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
