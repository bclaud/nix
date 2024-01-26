{config, lib, pkgs, ...}:
with lib;
let 
  cfg = config.services.yubikeyAccess;
in 
{
  options.services.yubikeyAccess = {
    enable = mkEnableOption "Support for authentication with yubikey including for ssh and GPG";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    environment.systemPackages  = with pkgs;[ 
      yubikey-manager 
      pinentry-curses 
      libfido2
    ];

    programs.ssh.startAgent = false;
    services.pcscd.enable = true;
  };
}