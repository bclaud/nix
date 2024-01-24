# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }:
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
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

      ./hyprland
  ] ++ import ./common;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.unison-nix.overlay
      postman_overlay
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = ["electron-24.8.6" "electron-25.9.0"];
    };
  };

  desktops.hyprland.enable = true;

  # TODO: Set your username
  home = {
    username = "nclaud";
    homeDirectory = "/home/nclaud";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ firefox librewolf lazydocker lazygit bottom logseq libreoffice insomnia unison-ucm yuzu-ea vscode-fhs postman mangohud  (vivaldi.override {
        proprietaryCodecs = true; 
        enableWidevine = true;
        widevine-cdm = pkgs.widevine-cdm;
        vivaldi-ffmpeg-codecs = pkgs.vivaldi-ffmpeg-codecs;
      }) aichat foliate gh mpv jq ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
