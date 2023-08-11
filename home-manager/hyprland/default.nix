{pkgs, inputs, ...}:
    {
     # not well configured dependencies (should not be at PATH IMO)
     home.packages = with pkgs; [ wofi gnome.nautilus pamixer pavucontrol wl-clipboard ];

     # TODO Login TTY | not working, only on system level

     programs = {

       waybar = {
         # TODO fix this not cool
         package = inputs.hyprland.packages."x86_64-linux".waybar-hyprland;
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

             modules-left = [ "wlr/workspaces" ];
             modules-center = [ "clock" ];
             modules-right = [ 
               "network"
               "pulseaudio"
               "cpu"
               "memory"
             ];

             "wlr/workspaces" = {
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
               interval = 3;
             };
             memory = {
               format = "  {used:0.1f}G/{total:0.1f}G";
               interval = 5;
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
     wayland.windowManager.hyprland.extraConfig = ''

     exec-once=waybar

     general {
     # See https://wiki.hyprland.org/Configuring/Variables/ for more

     gaps_in = 5
     gaps_out = 20
     border_size = 2
     col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
     col.inactive_border = rgba(595959aa)

     layout = dwindle
     }

     decoration {
     # See https://wiki.hyprland.org/Configuring/Variables/ for more

     rounding = 10

     drop_shadow = yes
     shadow_range = 4
     shadow_render_power = 3
     col.shadow = rgba(1a1a1aee)
     }

     animations {
     enabled = yes

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
  
    bind = $mod, T, exec, foot
    bind = $mod, B, exec, firefox
    bind = $mod, C, killactive, 
    bind = $mod, E, exec, nautilus
    bind = $mod, V, togglefloating, 
    bind = $mod, S, exec, wofi --show drun
    bind = $mod, O, togglesplit, # dwindle
    bind = $mod, F, fullscreen

    # Move focus with mod + arrow keys
    bind = $mod, l , movefocus, l
    bind = $mod, h, movefocus, r
    bind = $mod, k, movefocus, u
    bind = $mod, j, movefocus, d
  
     # workspaces
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
       '';
    }
