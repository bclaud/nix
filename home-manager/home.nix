# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let

in
{
  imports = [
    inputs.nix-colors.homeManagerModule

    ./common
    ./desktop/hyprland
    ./features/gh.nix
  ];

  home = {
    username = "nclaud";
    homeDirectory = "/home/nclaud";
  };

  desktops.hyprland = {
    enable = lib.mkIf (osConfig.claud.desktop == "hyprland") true;
    wallpaper = ../wallpapers/wallpaper1.jpg;
  };

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-city-dark;

  programs.home-manager.enable = true;

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      frame_timing = true;
      cpu_stats = true;
      cpu_temp = true;
      gpu_stats = true;
      gpu_temp = true;
      ram = true;
      vram = true;
      hud_compact = false;

      # Hide until toggled

      toggle_hud = "Shift_L+F1";
      toggle_hud_position = "Shift_L+F2";
      toggle_logging = "Shift_L+F3";
      reload_cfg = "Shift_L+F4";
    };
  };

  programs.helix = {
    enable = true;
    # editor = {
    #   line-number = "relative";
    # };
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  home.packages = with pkgs; [
    aichat
    bottom
    beekeeper-studio
    chromium
    firefox
    foliate
    #idea-community-fhs
    #jetbrains.idea-community
    #jetbrains.pycharm-community
    vscode-fhs
    zed-editor
    jq
    lazydocker
    lazygit
    libreoffice
    #logseq
    mpv
    postman
    scrcpy
    winbox
    ryujinx
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
