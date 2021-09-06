{config, pkgs, nixpkgs, system, dns, ...}:
let
   util = dns.util.${system};
in
{
  services.bind = {
    enable = true;
    zones = {
      "timmi.johannesloetzsch.de" = {
        master = true;
        file = util.writeZone "timmi.johannesloetzsch.de" (import ./dns/timmi.johannesloetzsch.de.nix {inherit dns;});
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
