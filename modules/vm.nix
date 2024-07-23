{ config, pkgs, lib, ... }:

let
  libvirtdEnable = config.virtualisation.libvirtd.enable;
in
{

  config = lib.mkIf libvirtdEnable {

  # Enable dconf (System Management Tool) programs.dconf.enable = true;

    # Add user to libvirtd group
    users.users.nclaud.extraGroups = [ "libvirtd" ];

    # Install necessary packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    # Manage the virtualisation services
    virtualisation = {
      libvirtd = {
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
