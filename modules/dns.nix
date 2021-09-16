{config, pkgs, nixpkgs, system, dns, ...}:
let
   util = dns.util.${system};
in
{
  networking.domain = "timmi.johannesloetzsch.de";

  services.bind = {
    enable = true;
    zones = {
      "${config.networking.domain}" = {
        master = true;
        file = util.writeZone "${config.networking.domain}" (import (./dns + "/${config.networking.domain}.nix") {inherit dns;});
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
