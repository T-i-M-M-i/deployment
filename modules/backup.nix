{ config, pkgs, nixpkgs, ... }:
{
  sops.secrets."restic-password" = {
    sopsFile = ../sops/secrets/restic-password.json;
  };

  services.restic.backups = {
    "localbackup" = {
      initialize = true;
      passwordFile = "/run/secrets/restic-password";
      repository = "/root/backup-target";
      paths = [ "/root/backup" ];
      timerConfig = { OnCalendar = "hourly"; };
      pruneOpts = [ "--keep-last 10" "--keep-hourly 24" "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" "--keep-yearly 100" ];
    };
  };
}
