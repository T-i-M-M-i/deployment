{
  description = "TiMMi Server setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, dns }:
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
          ./configuration.nix
        ];
      };
    };
  };
}
