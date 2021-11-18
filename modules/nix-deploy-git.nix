{ config, pkgs, ... }:

{
  services.nix-deploy-git = {
    enable = true;
    keys = [ ## J03
             "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW+YfsFtRz1h/0ubcKU+LyGfxH505yUkbWa5VtRFNWF2fjTAYGj6o5M4dt+fv1h370HXvvOBtt8sIlWQgMsD10+9mvjdXWhTcpnYPx4yWuyEERE1/1BhItrog6XJKAedbCDpQQ+POoewouiHWVAUfFByPj5RXuE8zKUeIEkGev/QKrKTLnTcS8zFs/yrokf1qYYR571B3U8IPDjpV/Y1GieG3MSNaefIMCwAAup1gPkUA0XZ4A1L7NdEiUEHlceKVu9eYiWUM+wDRunBXnLHubeGyP8KmBA7PNKgml3WWRNTZjqNQk4u9Bl+Qea5eCkD8KI257EqgXYXy0QBWNyF8X j03@l302"
             ## Winzlieb
             "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3iUaE0wXfRfG48bLs3pCSRi3TqH8a9yuh0JfycRv/Wai+hwJ/VopqxvN+L+NVFSEGWeTAvQRDzJZhgVgP29zrWALGnuvGCSi6jeuzhm57R2ebZcnXkS3fYiowfV34BJSmYkzM3mIg8ujxIp6R/7LqCx+7IKZfLqjeWAMFzVvZcF2aIs2OP59EWJYJN8fKSXpoMk6elnDwvxHD6zzNMhLu+n/7vKJccUoqJaEaPMd/AWyBi2aFn3C1btkFQ5fT8bO9Ob9t5eh97cyny9MAvlxPIHOR/xbJ80WMgVeqst/rb8atafe4UJVf643lzmzlbyxErBGAaeTY3p9Yc93QdvVP basti@basti-ThinkPad-T530"
             ## JENKINS
             "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkmeUjdrHVaegkV5uneVNsyop1D63EN+A9TTkAalt0AOpTIsFb/kBwtgB2gEHOJNCPmqnPHJCPVwBhM/5/PJ4Y3kKMk/NUk17dqCMqJCPFuvEt9YysaPUyjx2KkSYHVdxcx9MKFeM8noTDHM4lI74+oPqi3Yd8OloPP1wvK9vOruSjZzf7GJSNSPQFuNGWm2KIx8K4fV9LYB8vvGwX45sIABCWWid88EBxLLo5F/wM18ShTDJ1DcnPqjOUfErWw5RIbfjTvn1rdq6fFZmsutqVPIrBq29yNI7ou3xYBfGTw3ur8qEvolzToisOCSxfkpYDnlN+1ua1/tPEFZnNFRg2GACC2CoKZh/Q93rh9Zc6feZYT7vdM8sfKAGbemXtTAg1bALMOd9pIOyQmNXRK2j3Xkbg/Cnbjaa3nD2ceRl9toKpCiY1kR85Wm/cR6A3YZ3TcsN/9SARXYR+TvETb1x848WBXQQhFcA5+bZLXGhUmY/NKnm4yiA3DSmMI2J4ANE= jenkins@timmi-test"  ## invoice
             "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTH8vZSHQ4OTaUlThDSGAuiXRGcXr9tn5jPbFWuWmzw4dcf0LicNbAhJ7wrSnyzI6v3FbnGvU3CRhVAfgXqtjV0V1okiDUwUqZqt/FpAnKhVwb0kei3xmqWcd4okULCx6HgSndoWOiIidAAd+ea776HqWu0UMqsFUB1FbHcjUlMp/UN3IIHLSMNN1iVZ+S4ijA6kpTHMfzXk3/is1gR6hawnqKriHWtuQwGHJ6Gz2O/DkekhEfqZ/poL1UKIuNNoF6xju9P1dKbpLg61TpQCMlfBLCuWUKgoDKmEcZNfD2LxWbJRJYcVu6y+ULPQuyygxZle+a+b+4qitZ67mdGRjBVbXbkVMy2wXLeq+TOGT7ISAC/bIvCSlTrsHN0xm5k8JBJs5O2CZtC3hD7Jfg2CTrBWXxKjL4TyY/OWnlRfbKbhDpg+j8MX+de6Fb8IFPNlA/AW70Ykyf/FH3rgxBvzUfA3tcRAO2rX3Nt5nsnwnh+53N6C38dvBnSKAxX6JdxaU= jenkins@timmi-test"  ## pro
  ];
    repos = [

      { name = "nixos";
        hooks = (pkgs.writeScriptBin "post-receive" ''
          #!${pkgs.runtimeShell}
          cd /etc/nixos
          sudo git remote set-url deploy /var/lib/deploy/nixos.git || sudo git remote add deploy /var/lib/deploy/nixos.git
          sudo git fetch deploy
          sudo git reset --hard deploy/master
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
      commands = [ { command = "ALL"; options = [ "SETENV" "NOPASSWD" ]; } ];  ## should be limited to nixos-rebuild or nix-env
    }
  ];
}
