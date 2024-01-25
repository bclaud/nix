{config, lib, ...}:
with lib;
let 
  cfg = config.claud.desktop;
in 
{

  config = mkIf (cfg == "gnome") {
    services.xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

    # TODO set video driver based on config
      videoDrivers = ["amdgpu"];
    
    };
  };
}