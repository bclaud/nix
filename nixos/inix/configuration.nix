# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vm.nix
    ];


    environment = {
      loginShellInit = ''
         if [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland &> /dev/null
         fi
      '';
    };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.memtest86.enable = true;

  networking.hostName = "inix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ bash fish ];

  # Change DNS
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # boot.kernelParams = ["intel_iommu=on"];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.displayManager.lightdm.enable = false;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.jellyfin = {
    enable = true;
    user = "nclaud";
    openFirewall = true;
  };

  services.languagetool = {
    enable = true;
    allowOrigin = "*";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nclaud = {
    isNormalUser = true;
    description = "nclaud";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # addtional hardware
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd rocmPackages.clr rocmPackages.rocm-smi];

  # aditional software
  services.udev.packages = [pkgs.yubikey-personalization pkgs.logitech-udev-rules ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    yubikey-manager
    pinentry-curses
    libfido2
    pciutils
    kitty
    solaar
    (pkgs.buildFHSUserEnv {
      name = "idea-community";
      targetPkgs = pkgs: [ ];
      multiPkgs = pkgs: [ pkgs.jetbrains.idea-community ];
      runScript = "idea-community $*";
    })
    (pkgs.buildFHSUserEnv {
      name = "pycharm-community";
      targetPkgs = pkgs: [ ];
      multiPkgs = pkgs: [ pkgs.jetbrains.pycharm-community ];
      runScript = "pycharm-community $*";
    })
    jetbrains.idea-community
    jetbrains.pycharm-community
    lact
    gamescope
    obs-studio
    #k3s
    #kubernetes-helm
  ];

  systemd.services.lact = {
    enable = true;
    description = "Radeon GPU";
    after = ["syslog.target" "systemd-modules-load.service" ];

    unitConfig = { ConditionPathExists = "${pkgs.lact}/bin/lact"; };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    wantedBy = [ "multi-user.target" ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # hyprland
  # programs.hyprland.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
  environment = {
    variables = {
      # WLR_BACKEND = "vulkan";
      # WLR_RENDERER = "vulkan";
      TZ = "America/Sao_Paulo"; # fix for firefox datetime ._.
    };
  };

  # fonts

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      fira-code
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  # due yubikey
  programs.ssh.startAgent = false;

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "nclaud" ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # required for yubikey
  services.pcscd.enable = true;

  #k3s
    # This is required so that pod can reach the API server (running on port 6443 by default)
  networking.firewall.allowedTCPPorts = [ 6443 ];
  #services.k3s= {
  #  enable = false;
  #  role = "server";
  #};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nix = { 
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [ "nclaud" ];
      };
    };
}

