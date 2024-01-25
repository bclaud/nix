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
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;

    # TODO set video driver based on config
      videoDrivers = ["amdgpu"];
    
    };
  };
}
