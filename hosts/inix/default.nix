# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default

      ./hardware-configuration.nix
      ../common/global
      ../../modules/desktop
      ../../modules/vm.nix
      ../../modules/solaar-logitech.nix
      ../../modules/yubikey-access.nix
      ../../modules/lact-radeon.nix
    ];


  claud.desktop = "hyprland";

  networking = {
    hostName = "inix"; # Define your hostname.
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ bash fish ];

  # Change DNS

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


  services.jellyfin = {
    enable = true;
    user = "nclaud";
    openFirewall = true;
  };

  services.languagetool = {
    enable = false;
    allowOrigin = "*";
  };

  services.i2p = {
    enable = false;
  };

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

  users.users.nclaud = {
    isNormalUser = true;
    description = "nclaud";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pciutils
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
  ];

  services.lact.enable = true;
  services.solaarLogitech.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.dbus.enable = true;

  environment = {
    variables = {
      TZ = "America/Sao_Paulo"; # fix for firefox datetime
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


  # Docker
  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.yubikey-access.enable = true;

  # home-manager
  home-manager = {
    extraSpecialArgs = { nixosConfig = config; inherit inputs; };
    users = {
      "nclaud" = import ../../home-manager/home.nix;
    };
  };

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
  system.stateVersion = "24.05"; # Did you read the comment?
  nix = { 
      settings = {
        experimental-features = [ "nix-command" "flakes" "repl-flake" ];
        auto-optimise-store = true;
        trusted-users = [ "nclaud" ];
      };
    };
}

