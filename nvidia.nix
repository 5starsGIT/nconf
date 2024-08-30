{ config, pkgs, ... }:

{
	hardware.opengl = {
		enable = true;
		driSupport = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		modesetting.enable = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.production;
	};
}
