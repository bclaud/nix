# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, nixosConfig, pkgs, ... }:
let

  postman_overlay = (final: prev: {
    postman = prev.postman.overrideAttrs (previousAttrs: {
      version = "10.18.10";
      src = pkgs.fetchurl {
        url = "https://dl.pstmn.io/download/version/10.18.10/linux64";
        name = "postman-10.18.10.tar.gz";
        sha256 = "sha256-CAY9b2O+1vROUEfGRReZex9Sh5lb3sIC4TExVHRL6Vo=";
      };
    });
  });

in
  {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./common
    ./desktop/hyprland
    ./features/gh.nix
  ];

  home = {
    username = "nclaud";
    homeDirectory = "/home/nclaud";
  };

  programs.home-manager.enable = true;

  nixpkgs = {
    overlays = [
      inputs.unison-nix.overlay
      postman_overlay
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  desktops.hyprland = {
    enable = lib.mkIf (nixosConfig.claud.desktop == "hyprland") true;
    wallpaper = ../wallpapers/whispers_muta.png;
  };

  home.packages = with pkgs; [ 
    aichat
    bottom
    firefox
    foliate
    insomnia
    jetbrains.idea-community
    jetbrains.pycharm-community
    jq
    lazydocker
    lazygit
    libreoffice
    librewolf
    logseq
    mpv
    postman
    unison-ucm
    vscode-fhs 
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
