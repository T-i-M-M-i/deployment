{
  description = "TiMMi Server setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-deploy-git = {
      url = "github:johannesloetzsch/nix-deploy-git/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, nix-deploy-git, dns }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    inherit (pkgs) lib;

    commonAttrs = {
      system = "x86_64-linux";
      extraArgs = { flake = self; inherit system dns; };
    };
    commonModules = [
      ./modules/nix.nix
      sops-nix.nixosModules.sops
      ./modules/sops.nix
      ./modules/default.nix
      ./modules/dns.nix
      ./modules/monitoring/client.nix
      ./modules/nginx/timmi.nix
      nix-deploy-git.nixosModule
      ./modules/nix-deploy-git.nix
    ];
  in
  rec {
    legacyPackages.${system} = (lib.mergeAttrs pkgs {
      timmi-nixos-deploy = import ./tools/deploy.nix { inherit pkgs; };
    });
 
    defaultPackage.${system} = legacyPackages.${system}.timmi-nixos-deploy;

    nixosConfigurations = {
  
      test = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/test/configuration.nix
          ./modules/binarycache/server.nix
          ./modules/monitoring/server.nix
          ./modules/jenkins.nix
          #./modules/de4l/kibana.nix  ## not required at the moment -> save memory
          #./modules/de4l/mqtt.nix  ## deprecated
        ];
      });
  
      staging = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/staging/configuration.nix
          ./modules/binarycache/client.nix
          ./modules/backup.nix
        ];
      });
 
      productive = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/productive/configuration.nix
          ./modules/binarycache/client.nix
          ./modules/nginx/timmi-public.nix
        ];
      });

    };
  };
}
