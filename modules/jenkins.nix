{ config, pkgs, nixpkgs, ... }:
{
  services.jenkins = {
    enable = true;

    ## Most configuration is possible via nix. Other configuration can be found at ~jenkins/{config.xml,credentials.xml}
    ## To manage user roles a plugin is required:
    ##   https://www.guru99.com/create-users-manage-permissions.html
  };
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
