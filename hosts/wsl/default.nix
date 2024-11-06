{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ../common/global
    ../../modules/solaar-logitech.nix
    ../../modules/yubikey-access.nix
    ../../modules/lact-radeon.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "nclaud";
    startMenuLaunchers = true;

    docker-desktop.enable = true;
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/nclaud/.config/sops/age/keys.txt";
  sops.secrets.github-token = { };

  services = {

    yubikeyAccess.enable = false;
    lact.enable = false;
    solaarLogitech.enable = false;

    openssh.enable = true;

    jellyfin = {
      enable = false;
      user = "nclaud";
      openFirewall = true;
    };

    kavita = {
      enable = false;
      tokenKeyFile = "/var/lib/kavita/token.key";
    };

    languagetool = {
      enable = false;
      allowOrigin = "*";
    };

    i2p = {
      enable = false;
    };

    zerotierone = {
      enable = false;
      # To remove networks, use the ZeroTier CLI: zerotier-cli leave <network-id>
      # TODO add secrets
      # joinNetworks = [];
    };

    k3s = {
      enable = false;
      role = "server";
    };

    davfs2 = {
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

  virtualisation = {

    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
  };

  environment = {
    shells = with pkgs; [
      bash
      fish
    ];

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
    hostName = "wsl"; # Define your hostname.
  };

  users = {
    defaultUserShell = pkgs.fish;

    users.nclaud = {
      isNormalUser = true;
      description = "nclaud";
      extraGroups = [
        "networkmanager"
        "wheel"
        config.services.davfs2.davGroup
      ];
      shell = pkgs.fish;
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
    fontconfig = {
      hinting.style = "full";
      hinting.enable = true;
    };
  };

  # home-manager
  home-manager = {
    useGlobalPkgs = true;

    extraSpecialArgs = {
      nixosConfig = config;
      inherit inputs;
    };

    users = {
      # TODO fix me
      "nclaud" = import ../../home-manager/home-wsl.nix;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # 6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
  ];

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294

  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = [ "default.target" ];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        if [ -e $i/node ]; then
          echo "Fixing vscode-server in $i..."
          ln -sf ${pkgs.nodejs_18}/bin/node $i/node
        fi
      done
    '';
  };

  # networking.firewall.allowedUDPPorts = [ 
  # ];
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
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      auto-optimise-store = true;
      trusted-users = [ "nclaud" ];
      access-tokens = [ config.sops.secrets.github-token.path ];
    };
  };
}
