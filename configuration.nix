# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./nvim.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ca";
    variant = "multix";
  };

  # Disable mouse acceleration
  services.libinput.mouse.accelProfile = "flat";

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alexandre Bennett";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "alex";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    htop
    thunderbird
    kitty
    wget
    xclip
    git
    firefox
    spotify
    dmenu
    j4-dmenu-desktop
    xfce.xfce4-pulseaudio-plugin
    syncthing
    gnome.gnome-disk-utility
    maim
    gh

    libimobiledevice
    ifuse

    (lutris.override {
      extraLibraries = pkgs: [
        gnome3.adwaita-icon-theme
      ];
    })
  ];

  services.picom.enable = true;

  hardware.steam-hardware.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord"
      "com.ktechpit.orion"
      "net.davidotek.pupgui2"
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fileSystems."Drive2" = {
    device = "/dev/sda1";
    mountPoint = "/home/alex/Drive2";
    fsType = "ext4";
    options = [
	"rw"
	"exec"
    ];
  };

  # Iphone shit
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  boot.kernelPatches = [ {
    name = "customUsbPollrate";
    patch = builtins.fetchurl { 
      url = "https://raw.githubusercontent.com/GloriousEggroll/Linux-Pollrate-Patch/main/pollrate.patch";
      sha256 = "0cgvra1qs96awwxv78z3nmxw8gqjxic91hhjs7xc8wwls425m36a";
    };
  } ];

  boot.kernelParams = [
    "usbcore.interrupt_interval_override=1532:007b:1,0c45:652f:2,0e6f:0185:1"
  ]; 
}
