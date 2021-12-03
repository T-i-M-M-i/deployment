{ config, pkgs, ... }:
{
  ## during usage, you can still overwrite then:
  ## > nix build --option substituters https://cache.nixos.org/
  ## > nix build --option substitute false

  nix.binaryCaches = [ "https://binarycache.servers.timmitransport.de/" ];
  nix.binaryCachePublicKeys = [ "binarycache.servers.timmitransport.de:YzP+MuSRG40O7H3EqFyq4+C7w9aKJXOWX1fkhmVCy/0=" ];
}
