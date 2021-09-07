{ config, pkgs, ... }:

{
  ## Test at commandline:
  ##   mosquitto_sub -L 'mqtt://timmiUser:timmiUser@mqtt.timmi.johannesloetzsch.de:1883/sensors/timmi/test'  ## warning: silently ignores missing permissions on a topic
  ##   mosquitto_pub -L 'mqtt://timmiDev:$PASSWORD@mqtt.timmi.johannesloetzsch.de:1883/sensors/timmi/test' -m 'hallo'  ## fails when unauthorized

  services.mosquitto = {
    enable = true;

    allowAnonymous = false;
    checkPasswords = true;  ## otherwise users are not authorised: https://github.com/NixOS/nixpkgs/issues/27130#issuecomment-914268460

    users = {
      "timmiUser" = {
        hashedPassword = "$7$101$L8pFShInNG80i3kp$7cYOCbv+w4q4bCQT0bzqcIpMUgVVI59pFNxeYbAmSj46eGJoy/AhC/NqloqyD6j1qeuLu/+voVZH/fY05c3w6g==";
        acl = [ "topic write sensors/timmi/#" ];
      };
      "timmiDev" = {
        hashedPassword = "$7$101$/BTWvDStDON8LomE$H+uDIaMtXdU/zpBf0lk27A/633CXpy8kge77C06i60ADPuZREz5FqkxFOS9VbB67q/IPrzOmGE/fWgBUN8akNw==";
        acl = [ "topic readwrite sensors/timmi/#" ];
      };
    };

    host = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];
}
