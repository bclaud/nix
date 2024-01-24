{config, lib, pkgs, inputs, ...}:
with lib;
let 
  cfg = config.desktops.hyprland;

  wofiStyle = {
    primaryAccent = "7911f5";
    secondaryAccent = "89b4fa";
    tertiaryAccent = "f5f5f5";
    primaryBackgroundRGBA = "rgba(17,17,27,0.8)";
    terciaryBackgroundRGBA = "rgba(27,27,43,0.8)";
    background = "11111B";
    opacity = "1";
  };

  grimblast = inputs.hyprwm-contrib.packages.${pkgs.system}.grimblast;
  grimblastBin = "${grimblast}/bin/grimblast";

in {

  options.desktops.hyprland = {
    enable = mkEnableOption "Hyprland as Window manager with essential tools as whole desktop environment";

    wallpaper = mkOption {
      default = ../../wallpapers/wallpaper1.jpg;
      description = "";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {

     # not well configured dependencies (should not be at PATH IMO)
     #wayland stuff
     home.packages = with pkgs; [ gnome.nautilus pavucontrol wl-clipboard mako grimblast hyprpaper cliphist wl-clip-persist pamixer ];

     home.sessionVariables = {
       MOZ_ENABLE_WAYLAND = 1;
       QT_QPA_PLATFORM = "wayland";
       LIBSEAT_BACKEND = "logind";
     };

     xdg.configFile."hypr/hyprpaper.conf".text = ''
     preload = ${../../wallpapers/wallpaper1.jpg}
     preload = ${../../wallpapers/whispers_muta.png}
     wallpaper = ,${cfg.wallpaper}
     '';

     # screensharing
     xdg.portal = {
       enable = true;
       extraPortals = [ inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
       configPackages = [ inputs.hyprland.packages."${pkgs.system}".hyprland ];
     };

     programs = {

       wofi = {
         enable = true;
         settings = {
           allow_images = true;
           term = "foot";
         };
         style = ''
         * {
           font-weight: bold;
         }
        #window {
          border-radius: 40px;
          background: ${wofiStyle.primaryBackgroundRGBA};
        }
        #input {
          border-radius: 100px;
          margin: 20px;
          padding: 15px 25px;
          background: ${wofiStyle.terciaryBackgroundRGBA};
          color: #${wofiStyle.tertiaryAccent};
        }
        #outer-box {
          font-weight: bold;
          font-size: 14px;
        }
        #entry {
          margin: 10px 80px;
          padding: 20px 20px;
          border-radius: 200px;
          color: #${wofiStyle.tertiaryAccent};
        }
        #entry:selected{
          background-color:#${wofiStyle.primaryAccent};
          color: #${wofiStyle.background};
        }
        #entry:hover {
        }
        '';
      };

       waybar = {
         style = builtins.readFile ./waybar.css;
         enable = true;
         settings = {
           "bar" = {
             layer = "top";
             position = "top";
             height = 28;
             width = null;
             exclusive = true;
             passthrough = false;
             spacing = 4;
             margin = null;
             fixed-center = true;
             ipc = false;

             modules-left = [ "hyprland/workspaces" ];
             modules-center = [ "clock" ];
             modules-right = [ 
               "network"
               "pulseaudio"
               "cpu"
               "memory"
             ];

             "hyprland/workspaces" = {
               format = "{name}";
               on-click = "activate";
               sort-by-number = true;
               on-scroll-up = "hyprctl dispatch workspace e+1";
               on-scroll-down = "hyprctl dispatch workspace e-1";
             };

             network = {
               format-wifi = " {essid}";
               format-ethernet = "{essid}";
               format-linked = "{ifname} (No IP) ";
               format-disconnected = "";
               tooltip = true;
               tooltip-format = ''
               {ifname}
               {ipaddr}/{cidr}
               Up: {bandwidthUpBits}
               Down: {bandwidthDownBits}'';
             };

             pulseaudio = {
               format = "{icon} {volume}%";
               format-muted = " Mute";
               format-bluetooth = " {volume}% {format_source}";
               format-bluetooth-muted = " Mute";
               format-source = " {volume}%";
               format-source-muted = "";
               format-icons = {
                 headphone = " ";
                 hands-free = "";
                 headset = "";
                 phone = "";
                 portable = "";
                 car = "";
                 default = [ "" "" "" ];
               };
               scroll-step = 5.0;
               on-click = "pamixer --toggle-mute";
               on-click-right = "pavucontrol";
               smooth-scrolling-threshold = 1;
             };

             cpu = {
               format = "󰍛  {usage}%";
               interval = 2;
             };
             memory = {
               format = "  {used:0.1f}G/{total:0.1f}G";
               interval = 2;
             };

             clock = {
               interval = 60;
               align = 0;
               rotate = 0;
               tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
               format = "  {:%I:%M %p}";
               format-alt = "  {:%a %b %d, %G}";

             };

           };
         };

       };
     };

     # hyprland config
     wayland.windowManager.hyprland.enable = true;
     wayland.windowManager.hyprland.systemd.enable = true;
     wayland.windowManager.hyprland.extraConfig = ''

     exec-once=waybar
     exec-once=mako
     exec-once=hyprpaper

     exec-once = wl-paste --type text --watch cliphist store #Stores only text data
     exec-once = wl-paste --type image --watch cliphist store #Stores only image data

     general {
     # See https://wiki.hyprland.org/Configuring/Variables/ for more

     gaps_in = 5
     gaps_out = 20
     border_size = 2
     col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
     col.inactive_border = rgba(595959aa)

     layout = dwindle
     resize_on_border = true

   }

   decoration {
     # See https://wiki.hyprland.org/Configuring/Variables/ for more

     rounding = 6

     drop_shadow = yes
     shadow_range = 4
     shadow_render_power = 3
     col.shadow = rgba(1a1a1aee)
   }

   animations {
     enabled = yes


     # Autocompletion, etc, take hyprland focus

     # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

     bezier = myBezier, 0.05, 0.9, 0.1, 1.05

     animation = windows, 1, 7, myBezier
     animation = windowsOut, 1, 7, default, popin 80%
     animation = border, 1, 10, default
     animation = borderangle, 1, 8, default
     animation = fade, 1, 7, default
     animation = workspaces, 1, 6, default
   }

   $mod = SUPERs

   bind = $mod, P, exec, ${grimblastBin} --notify copy output
   bind = SHIFT + $mod, P, exec, ${grimblastBin} --notify copy area
   bind = $mod, T, exec, foot
   bind = $mod, B, exec, firefox
   bind = $mod, C, killactive, 
   bind = $mod, E, exec, nautilus
   bind = $mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy
   bind = $mod, S, exec, wofi --show drun
   bind = $mod, O, togglesplit, # dwindle
   bind = $mod, F, fullscreen

    # Move focus with mod + arrow keys
    bind = $mod, l , movefocus, l
    bind = $mod, h, movefocus, r
    bind = $mod, k, movefocus, u
    bind = $mod, j, movefocus, d

     # workspaces
     bind = $mod, N, workspace, 1
     bind = $mod, M, workspace, 2

     binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
     ${builtins.concatStringsSep "\n" (builtins.genList (
       x: let
         ws = let
           c = (x + 1) / 10;
         in
         builtins.toString (x + 1 - (c * 10));
       in ''
       bind = $mod, ${ws}, workspace, ${toString (x + 1)}
       bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
       ''
       )
       10)}

       windowrulev2 = noborder, class:^(jetbrains-idea)(.*)$
       '';
     };
   }

