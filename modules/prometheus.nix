{ config, pkgs, nixpkgs, ... }:
{
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "meminfo" "filesystem" "filefd" "textfile" ];
      };
    };
    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
  #networking.firewall.allowedTCPPorts = [ 9090 ];  ## ssl+basicAuth via reverse-proxy only
}
