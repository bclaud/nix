{config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.services.lact;
in 
{
  options.services.lact = {
    enable = mkEnableOption "Enable Radeon GPU monitoring and tweaking";
  };

  config = mkIf cfg.enable {
    systemd.services.lact = {
      enable = true;
      description = "Radeon GPU";
      after = ["syslog.target" "systemd-modules-load.service" ];

      unitConfig = { ConditionPathExists = "${pkgs.lact}/bin/lact"; };

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };

      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = [ pkgs.lact ];
  };
}