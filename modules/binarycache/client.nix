{ config, pkgs, ... }:
{
  ## during usage, you can still overwrite then:
  ## > nix build --option substituters https://cache.nixos.org/
  ## > nix build --option substitute false

  nix.binaryCaches = [ "https://binarycache.timmi.johannesloetzsch.de/" ];
  #nix.binaryCachePublicKeys = [ "binarycache.timmi.johannesloetzsch.de:YzP+MuSRG40O7H3EqFyq4+C7w9aKJXOWX1fkhmVCy/0=" ];
}
