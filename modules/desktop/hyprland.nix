{config, lib, ...}:
with lib;
let 
  cfg = config.claud.desktop;
in 
{

  config = mkIf (cfg == "hyprland") {
    environment = {
      loginShellInit = ''
         if [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland &> /dev/null
         fi
      '';
    };

    services.xserver.enable = true;
    
    # TODO set video driver based on config
    services.xserver.videoDrivers = ["amdgpu"];
  };



}