{pkgs, ...}:
    {
     home.packages = with pkgs; [ wofi nautilus ]
     wayland.windowManager.hyprland.extraConfig = ''
     
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
     blur = yes
     blur_size = 3
     blur_passes = 1
     blur_new_optimizations = on

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
    bind = $mod, M, exit, 
    bind = $mod, E, exec, nautilus
    bind = $mod, V, togglefloating, 
    bind = $mod, S, exec, wofi --show drun
    bind = $mod, O, togglesplit, # dwindle

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