# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" "amdgpu" ];
  boot.extraModulePackages = [ ];

  # testing
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watchers" = 2048000;
  };

  boot.loader.systemd-boot.enable = true;
  systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f01f3e8f-3856-453d-ba4a-b7ea2946faa3";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1608-C117";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/70f9727e-b325-4f8f-be6c-c00d54b1ddba"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # AMD GPU
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ 
        amdvlk
        libva
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
        #rocmPackages.clr
        #rocmPackages.clr.icd
        #rocmPackages.hipblas
        #rocmPackages.rocblas
        #rocmPackages.rocm-comgr
        #rocmPackages.rocm-runtime
        #rocmPackages.rocm-smi
        #rocmPackages.rocsolver
        #rocmPackages.rocsparse
        vaapiVdpau
      ];
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # current 6600m doesn't support default gfx1032 afaik
  environment.variables = { HSA_OVERRIDE_GFX_VERSION="10.3.0"; };

}

