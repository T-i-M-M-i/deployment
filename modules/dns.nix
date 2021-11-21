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
      "servers.timmitransport.de" = {  ## serving the same zone for another domain is not required, but allows moving there, one the NS records are set for the subdomain
        master = true;
        file = util.writeZone "servers.timmitransport.de" (import (./dns + "/${config.networking.domain}.nix") {inherit dns;});
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
