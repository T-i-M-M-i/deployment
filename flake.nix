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
      nix-deploy-git.nixosModule
      ./modules/nix.nix
      ./modules/default.nix
      ./modules/nix-deploy-git.nix
      ./modules/dns.nix
    ];
  in
  {
    legacyPackages.x86_64-linux = pkgs;
 
    nixosConfigurations = {
  
      timmi-test = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/test/configuration.nix
          ./modules/nginx.nix
          ./modules/binarycache.nix
          ./modules/monitoring.nix
          ./modules/jenkins.nix
          ./modules/de4l/mqtt.nix
          ./modules/de4l/kibana.nix
        ];
      });
  
      timmi-staging = nixpkgs.lib.nixosSystem (lib.mergeAttrs commonAttrs {
        modules = commonModules ++ [
          ./hosts/staging/configuration.nix
        ];
      });

    };
  };
}
