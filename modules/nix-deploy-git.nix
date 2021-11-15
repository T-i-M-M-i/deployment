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
          sudo git pull deploy master || sudo git reset --hard deploy/master
          sudo nixos-rebuild switch
        '');
      }

      { name = "pro";
        hooks = (pkgs.writeScriptBin "post-receive" ''
          #!${pkgs.runtimeShell} -x
          unset GIT_DIR
          RUN_BASE_DIR="/var/lib/deploy/run"
          RUN_DIR="$RUN_BASE_DIR/pro"
          [ -d $RUN_BASE_DIR ] || mkdir -p $RUN_BASE_DIR
          [ -d $RUN_DIR ] && rm -r $RUN_DIR
          (cd $RUN_BASE_DIR; git clone /var/lib/deploy/pro.git -b staging)
          (cd $RUN_DIR; nix run)
        '');
      }

      { name = "invoice";
        hooks = (pkgs.writeScriptBin "post-receive" ''
          #!${pkgs.runtimeShell} -x
          unset GIT_DIR
          RUN_BASE_DIR="/var/lib/deploy/run"
          RUN_DIR="$RUN_BASE_DIR/invoice"
          [ -d $RUN_BASE_DIR ] || mkdir -p $RUN_BASE_DIR
          [ -d $RUN_DIR ] && rm -r $RUN_DIR
          (cd $RUN_BASE_DIR; git clone /var/lib/deploy/invoice.git -b staging)
          (cd $RUN_DIR; nix develop -c pm2 start pm2.json --only invoice-jar)
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
