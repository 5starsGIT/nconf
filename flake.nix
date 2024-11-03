{
description = "nix flake";

inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  nix-stable.url = "github:nixos/nixpkgs/nixos-24.05";
	home-manager.url = "github:nix-community/home-manager/master";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
	nix-flatpak.url = "github:gmodena/nix-flatpak";
};

outputs = inputs@{ self, nixpkgs, nix-stable, home-manager, nix-flatpak, ... }: 
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  stable = import nix-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
	nixosConfigurations = {
		nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ 
				./configuration.nix 
        {
          _module.args = { inherit stable; };
        }
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.alex = import ./home.nix;
				}
				nix-flatpak.nixosModules.nix-flatpak
			];
		};
	};
};

}
