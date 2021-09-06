{ config, pkgs, nixpkgs, ... }:
{
  services.jenkins = {
    enable = true;

    ## Most configuration is possible via nix. Other configuration can be found at ~jenkins/{config.xml,credentials.xml}

    ## To manage user roles a plugin is required:
    ##   https://www.guru99.com/create-users-manage-permissions.html

    ## After changing job definitions and `nixos-rebuild switch`: debug with `journalctl -u jenkins-job-builder` and run `systemctl restart jenkins`
    jobBuilder = {
      enable = true;
      nixJobs = [
        {
          job = let url = "git@github.com:T-i-M-M-i/invoice.git"; in {
            name = "timmi-invoice";
            scm = [{ git = {
              browser-url = "https://github.com/T-i-M-M-i/invoice/";
              url = url;
              branches = [ "master" ];
              credentials-id = "711db868-8bb9-444c-ae60-a756b5100c2a";
            }; }];
            triggers = [ "github" ];
            properties = [
              { github.url = url; }
            ];
            wrappers = [
              { credentials-binding = [
                  { text = {
                      variable = "GITHUB_TOKEN";
                      credential-id = "ef4602c8-14bc-4ba4-9dda-e1e6dadad8c4";
                  }; }
              ]; }
            ];
            builders = [ { shell = "/run/current-system/sw/bin/nix build"; } ];
          };
        }
      ];
    };
  };

  #networking.firewall.allowedTCPPorts = [ 8080 ];
}
