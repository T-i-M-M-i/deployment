{ config, pkgs, ... }:

{
  services.nix-deploy-git = {
    enable = true;
    keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW+YfsFtRz1h/0ubcKU+LyGfxH505yUkbWa5VtRFNWF2fjTAYGj6o5M4dt+fv1h370HXvvOBtt8sIlWQgMsD10+9mvjdXWhTcpnYPx4yWuyEERE1/1BhItrog6XJKAedbCDpQQ+POoewouiHWVAUfFByPj5RXuE8zKUeIEkGev/QKrKTLnTcS8zFs/yrokf1qYYR571B3U8IPDjpV/Y1GieG3MSNaefIMCwAAup1gPkUA0XZ4A1L7NdEiUEHlceKVu9eYiWUM+wDRunBXnLHubeGyP8KmBA7PNKgml3WWRNTZjqNQk4u9Bl+Qea5eCkD8KI257EqgXYXy0QBWNyF8X j03@l302" ];
    repos = [
      { name = "nixos";
        hooks = (pkgs.writeScriptBin "post-receive" ''
          #!${pkgs.runtimeShell}

          cd /etc/nixos
          sudo git remote add deploy /var/lib/deploy/nixos.git
          sudo git pull
          sudo nixos-rebuild switch
        '');
      }
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ config.services.nix-deploy-git.user ];
      commands = [ { command = "ALL"; options = [ "SETENV" "NOPASSWD" ]; } ];  ## could be limited to nixos-rebuild or nix-env
    }
  ];
}
