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

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/nclaud/.config/sops/age/keys.txt";
  sops.secrets.github-token = { };

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

    zerotierone = {
      enable = true;
      # To remove networks, use the ZeroTier CLI: zerotier-cli leave <network-id>
      # TODO add secrets
      # joinNetworks = [];
    };

  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    fish.enable = true;
  };

  virtualisation = { 

    docker.enable = true;

    libvirtd.enable = true;
  };

  environment = {
    shells = with pkgs; [ bash fish ];

    systemPackages = with pkgs; [
      vim 
      wget
      pciutils
    ];

    variables = {
      TZ = "America/Sao_Paulo"; # fix for firefox datetime
    };
  };


  networking = {
    hostName = "inix"; # Define your hostname.
    networkmanager.enable = false;
    useDHCP = true;
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
    useGlobalPkgs = true;

    extraSpecialArgs = { 
      nixosConfig = config;
      inherit inputs; 
    };

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

