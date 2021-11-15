{
  description = "TiMMi Server setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-deploy-git = {
      url = "github:johannesloetzsch/nix-deploy-git/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-deploy-git, home-manager, dns }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    lib = pkgs.lib;

    commonAttrs = {
      system = "x86_64-linux";
      extraArgs = { flake = self; inherit system dns; };
    };
    commonModules = [
      ./modules/nix.nix
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
          ./modules/monitoring/server.nix
          ./modules/binarycache/server.nix
          ./modules/jenkins.nix
          ./modules/de4l/mqtt.nix
          ./modules/de4l/kibana.nix
        ];
      });
  
      staging = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/staging/configuration.nix
          ./modules/binarycache/client.nix
        ];
      });

    };
  };
}
