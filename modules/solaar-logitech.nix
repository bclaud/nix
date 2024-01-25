{config, lib, pkgs, ...}:
with lib;
let 
  cfg = config.services.solaarLogitech;
in 
{
  options.services.solaarLogitech = {
    enable = mkEnableOption "Enable solaar program and necessary services";
  };

  config = mkIf cfg.enable {
    
    services.udev.packages = [ pkgs.logitech-udev-rules ];

    environment.systemPackages = [
      pkgs.solaar
    ];

  };
}