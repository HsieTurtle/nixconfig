# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "kame"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostId = "16eba685";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat2-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -f `/nixpkgs -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    gitAndTools.gitFull
    tmux
    chromium 
    rxvt_unicode
    vim
    xclip
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = false;


  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      linux = pkgs.linuxPackages_latest.kernel;
      linuxPackages = pkgs.linuxPackages_latest;
    };
    chromium = {
      enablePepperFlash = true;
      jre = true;
    };
    allowUnfree = true;
    virtualbox.enableExtensionPack = true;
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      terminus_font
      ubuntu_font_family
      unifont
      dejavu_fonts
      source-code-pro
    ];
  };

  nix.useSandbox = true;
  nix.extraOptions = "auto-optimize-store = true";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  programs.zsh.enable = true;
  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.xmonad.enable = true;
  # services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  # services.xserver.windowManager.default = "xmonad";
  # services.xserver.desktopManager.default = "none";
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.dominic = {
    name = "dominic";
    extraGroups = [ "wheel" "audio" "networkmanager" "vboxusers" ];
    createHome = true;
    home = "/home/dominic";
    isNormalUser = true;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  # shit that might be me being stupid

}
