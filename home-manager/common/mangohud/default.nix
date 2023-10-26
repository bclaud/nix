
{pkgs, ...}: {
  # In most situations, it depends on gamescope
  home.packages = with pkgs; [mangohud];
  xdg.configFile."MangoHud/MangoHud.conf".source = ./MangoHud.conf;
  }
