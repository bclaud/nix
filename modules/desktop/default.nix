{ config, lib, ... }:
with lib;
{
  imports = [
    ./hyprland.nix
    ./gnome.nix
  ];

  options.claud = {
    desktop = mkOption {
      default = "gnome";
      description = "setup the environment for selected desktop";
      type = types.str;
    };
  };

}
