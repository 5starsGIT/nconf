{
description = "nix flake";

inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	home-manager.url = "github:nix-community/home-manager/release-24.05";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
	nix-flatpak.url = "github:gmodena/nix-flatpak";
};

outputs = inputs@{ self, nixpkgs, home-manager, nix-flatpak, ... }: 
{
	nixosConfigurations = {
		nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ 
				./configuration.nix 
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
