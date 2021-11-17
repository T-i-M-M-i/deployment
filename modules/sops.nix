{ config, lib, pkgs, ... }:
{
  sops.gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];

  sops.defaultSopsFile = ../sops/secrets/default.json;
  sops.defaultSopsFormat = "json";

  sops.secrets."timmi-env-test-timmi" = {
    sopsFile = ../sops/secrets/timmi-env/test/timmi;
    format = "binary";
    mode = "0444";
  };
  sops.secrets."timmi-env-test-timmi-invoice" = {
    sopsFile = ../sops/secrets/timmi-env/test/timmi-invoice;
    format = "binary";
    mode = "0444";
  };
  sops.secrets."timmi-env-staging-timmi" = {
    sopsFile = ../sops/secrets/timmi-env/staging/timmi;
    format = "binary";
    owner = "deploy";
  };
  sops.secrets."timmi-env-staging-timmi-invoice" = {
    sopsFile = ../sops/secrets/timmi-env/staging/timmi-invoice;
    format = "binary";
    owner = "deploy";
  };
  sops.secrets."timmi-env-productive-timmi" = {
    sopsFile = ../sops/secrets/timmi-env/productive/timmi;
    format = "binary";
    owner = "deploy";
  };
  sops.secrets."timmi-env-productive-timmi-invoice" = {
    sopsFile = ../sops/secrets/timmi-env/productive/timmi-invoice;
    format = "binary";
    owner = "deploy";
  };

  environment.etc."timmi" = {
    enable = true;
    source = config.sops.secrets."timmi-env-${config.networking.hostName}-timmi".path;
  };
  environment.etc."timmi-invoice" = {
    enable = true;
    source = config.sops.secrets."timmi-env-${config.networking.hostName}-timmi-invoice".path;
  };
}
