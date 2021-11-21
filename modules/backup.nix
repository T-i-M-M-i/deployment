{ config, pkgs, nixpkgs, ... }:
{

 systemd = {
    services.backup-mongodump = {
      serviceConfig.Type = "oneshot";
      script = ''
        . /run/secrets/timmi-env-productive-timmi
        cd /root/backup/productive/
        ${pkgs.mongodb-tools}/bin/mongodump --uri $MONGO_URI
      '';
    };
    timers.backup-mongodump = {
      wantedBy = [ "timers.target" ];
      partOf = [ "backup-mongodump.service" ];
      timerConfig.OnCalendar = "*-*-* *:55:00";
    };
  };

  sops.secrets."restic-password" = {
    sopsFile = ../sops/secrets/restic-password.json;
  };

  services.restic.backups = {
    "localbackup" = {
      initialize = true;
      passwordFile = "/run/secrets/restic-password";
      repository = "/root/backup-target";
      paths = [ "/root/backup" ];
      timerConfig.OnCalendar = "hourly";
      pruneOpts = [ "--keep-last 10" "--keep-hourly 24" "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" "--keep-yearly 100" ];
    };
  };
}
