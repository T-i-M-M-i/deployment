{ pkgs ? import <nixpkgs> {} }:

let
  TEST="test.timmi.johannesloetzsch.de";
  STAGING="staging.timmi.johannesloetzsch.de";

in
pkgs.writeScriptBin "timmi-nixos-deploy" ''
  #!${pkgs.runtimeShell}

  export PATH="${pkgs.lib.makeBinPath (with pkgs;[ git ])}:$PATH"

  function git_remote_add() {
    git remote set-url $1 $2 || git remote add $1 $2
  }

  function setup_remotes() {
    git_remote_add deploy-test deploy@${TEST}:/var/lib/deploy/nixos.git
    git_remote_add deploy-staging deploy@${STAGING}:/var/lib/deploy/nixos.git
  }

  function deploy() {
    git push -u deploy-test master
    git push -u deploy-staging master
  }

  setup_remotes
  deploy
''