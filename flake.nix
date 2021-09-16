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
  in
  {
    legacyPackages.x86_64-linux = pkgs;
 
    nixosConfigurations = {
  
      timmi-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        extraArgs = { flake = self; inherit system dns; };
        modules = [
          ./hosts/test/configuration.nix
          nix-deploy-git.nixosModule
        ];
      };
  
      timmi-staging = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        extraArgs = { flake = self; inherit system dns; };
        modules = [
          ./hosts/staging/configuration.nix
          nix-deploy-git.nixosModule
        ];
      };

    };
  };
}
