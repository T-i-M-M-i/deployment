{ config, pkgs, nixpkgs, ... }:
{
  services.jenkins = {
    enable = true;
  };
  #networking.firewall.allowedTCPPorts = [ 8080 ];  ## ssl via reverse-proxy only
}
