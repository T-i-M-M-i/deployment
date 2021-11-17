{ config, pkgs, ... }:
{
  imports = [
    ../nginx/binarycache.nix
  ];

  ## An alternative might be switching to https://github.com/thoughtpolice/eris

  services.nix-serve = {
    enable = true;

    ## nix-serve fails with current nixos-unstable: https://github.com/edolstra/nix-serve/issues/28 when signing is enabled
    #secretKeyFile = "/var/cache-priv-key.pem";  ## generated as described in https://nixos.wiki/wiki/Binary_Cache#1._Generating_a_private.2Fpublic_keypair

    ## To get the correct permissions on the secretKeyFile, we may want use systemd.tmpfiles.rules:
    ## https://github.com/Mic92/doctor-cluster-config/commit/303858529e02fd6f6a938dc7c76967cd410ed564#diff-8c0e51ff0928fd4e5f22f499d692a2e585e3f4adc3d24e866a7ea48eec26ca22L10
    #systemd.tmpfiles.rules = [
    #  "C /run/cache-priv-key.pem 400 nix-serve root - /var/cache-priv-key.pem"
    #];

  };
}
