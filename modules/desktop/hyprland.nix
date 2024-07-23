{pkgs, config, lib, ...}:
with lib;
let 
  cfg = config.claud.desktop;
  bluetoothEnabled = config.hardware.bluetooth.enable;
in 
{

  config = mkIf (cfg == "hyprland") {
    programs.hyprland.enable = true;

    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment = {
      loginShellInit = ''
         if [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland &> /dev/null
         fi
      '';
    };

    services = {
        # TODO something is enabling this option
      displayManager.sddm.enable = false;

      xserver = {
        enable = true;

        xkb = {
          layout = "us";
          variant = "";
        };

        displayManager.lightdm.enable = false;
        displayManager.gdm.enable = false;

        # TODO set video driver based on config
        videoDrivers = ["amdgpu"];

      };

      dbus.enable = true;
    };

    hardware.pulseaudio ={
      enable = false;
      package = pkgs.pulseaudioFull;
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

  };
}
