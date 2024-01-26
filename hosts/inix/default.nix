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


  claud = {
    desktop = "hyprland";
  };

  services = {

    yubikeyAccess.enable = true;
    lact.enable = true;
    solaarLogitech.enable = false;

    openssh.enable = true;

    jellyfin = {
      enable = true;
      user = "nclaud";
      openFirewall = true;
    };

    languagetool = {
      enable = false;
      allowOrigin = "*";
    };

    i2p = {
      enable = false;
    };

  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    fish.enable = true;
  };

  virtualisation.docker.enable = true;

  environment = {
    shells = with pkgs; [ bash fish ];

    systemPackages = with pkgs; [
      vim 
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

    variables = {
      TZ = "America/Sao_Paulo"; # fix for firefox datetime
    };
  };


  networking = {
    hostName = "inix"; # Define your hostname.
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  users = {
    defaultUserShell = pkgs.fish;

    users.nclaud = {
      isNormalUser = true;
      description = "nclaud";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.fish;
      packages = with pkgs; [
      ];
    };
  };


  time.timeZone = "America/Sao_Paulo";
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



  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      fira-code
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };


  # home-manager
  home-manager = {
    extraSpecialArgs = { nixosConfig = config; inherit inputs; };
    users = {
      "nclaud" = import ../../home-manager/home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

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

