# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, stable, ... }:

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
  services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs rec {
        src = pkgs.fetchgit {
          url = "https://github.com/5starsGIT/dwm-desktop";
          rev = "9bdf5bcaf0ffa5eb185dfece0120fb2896dd67fd";
          hash = "sha256-fxgylFX7JK89aBQXt96z2M0MtBHKxmwF0Hv74iEkF8Q=";
        };
      };
  };
  services.displayManager.defaultSession = "none+dwm";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ca";
    variant = "multix";
  };

  # Disable mouse acceleration
  services.libinput.mouse.accelProfile = "flat";
  services.libinput.mouse.middleEmulation = false;

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
/*  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };
*/

  # Enable sound with pipewire.
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
    firefox-beta
    chromium
    spotify
    dmenu
    j4-dmenu-desktop
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-timer-plugin
    syncthing
    gnome-disk-utility
    maim
    gh
    yt-dlp

    libimobiledevice
    ifuse

    (lutris.override {
      extraLibraries = pkgs: [
        adwaita-icon-theme
        wine
      ];
    })

    evince
    libreoffice
    gnumeric
    onlyoffice-bin

    obsidian

    #printing
    foomatic-db
    foomatic-db-ppds
    foomatic-db-nonfree
    foomatic-db-ppds-withNonfreeDb
    molsketch

    ani-cli

    pavucontrol
    playerctl
    pamixer
    feh
  ];

  services.picom.enable = true;

  hardware.steam-hardware.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ stable.xdg-desktop-portal-gtk ];
  };

  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord"
      "com.ktechpit.orion"
      "net.davidotek.pupgui2"
      "dev.vencord.Vesktop"
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

  environment.extraInit = ''
    xset s off -dpms
  '';

  boot.kernelPatches = [ 
    {
      name = "customUsbPollrate";
      patch = builtins.fetchurl { 
        url = "https://raw.githubusercontent.com/GloriousEggroll/Linux-Pollrate-Patch/main/pollrate.patch";
        sha256 = "0cgvra1qs96awwxv78z3nmxw8gqjxic91hhjs7xc8wwls425m36a";
      }; 
    } 
  ];

  boot.kernelParams = [
    "usbcore.interrupt_interval_override=1532:007b:1,0c45:652f:2,0e6f:0185:1"
  ];  

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }];

  services.xserver.exportConfiguration = true;

  services.xserver.screenSection = ''
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "nvidiaXineramaInfoOrder" "DP-2"
    Option         "metamodes" "2560x1440_165 +0+0"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
  '';

  services.xserver.extraDisplaySettings = ''
    Depth 24
  '';

  services.xserver.monitorSection = ''
    HorizSync       242.0 - 242.0
    VertRefresh     48.0 - 165.0
    Option         "DPMS"
  '';

}
