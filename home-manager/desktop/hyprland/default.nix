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

  mod = "SUPER";
  modshift = "${mod}SHIFT";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10} (stolen from fufie)
  workspaces = builtins.concatLists (builtins.genList (
    x: let
      ws = let
        c = (x + 1) / 10;
      in
      builtins.toString (x + 1 - (c * 10));
    in [
      "${mod}, ${ws}, workspace, ${toString (x + 1)}"
      "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    ]
    )
    10);

in {

  options.desktops.hyprland = {
    enable = mkEnableOption "Hyprland as Window manager with essential tools as whole desktop environment";

    wallpaper = mkOption {
      default = ../../../wallpapers/wallpaper1.jpg;
      description = "";
      type = types.path;
    };
  };

  config = mkIf cfg.enable {

     # not well configured dependencies (should not be at PATH IMO)
     #wayland stuff
     home.packages = with pkgs; [ nautilus pavucontrol wl-clipboard mako grimblast hyprpaper cliphist wl-clip-persist pamixer ];

     home.pointerCursor = {
       gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      gtk = {
        enable = true;
        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
        };

        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };

        font = {
          name = "Sans";
          size = 11;
        };
      };

     home.sessionVariables = {
       MOZ_ENABLE_WAYLAND = 1;
       QT_QPA_PLATFORM = "wayland";
       LIBSEAT_BACKEND = "logind";
     };

     xdg.configFile."hypr/hyprpaper.conf".text = ''
     preload = ${../../../wallpapers/wallpaper1.jpg}
     preload = ${../../../wallpapers/whispers_muta.png}
     wallpaper = ,${cfg.wallpaper}
     '';

     #screensharing
     xdg.portal = {
       enable = true;
       extraPortals = [ 
         pkgs.xdg-desktop-portal-hyprland 
         pkgs.xdg-desktop-portal-gtk
       ];
       configPackages = [ pkgs.hyprland ];
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
        style = ''
	* {
	font-size: 16px;
		font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
    		font-weight: bold;
	}
	window#waybar {
		    background-color: rgba(26,27,38,0);
    		border-bottom: 1px solid rgba(26,27,38,0);
    		border-radius: 0px;
		    color: #${config.colorScheme.palette.base0F};
	}
	#workspaces {
		    background: linear-gradient(180deg, #${config.colorScheme.palette.base00}, #${config.colorScheme.palette.base01});
    		margin: 5px;
    		padding: 0px 1px;
    		border-radius: 15px;
    		border: 0px;
    		font-style: normal;
    		color: #${config.colorScheme.palette.base00};
	}
	#workspaces button {
    		padding: 0px 5px;
    		margin: 4px 3px;
    		border-radius: 15px;
    		border: 0px;
    		color: #${config.colorScheme.palette.base00};
    		background-color: #${config.colorScheme.palette.base00};
    		opacity: 1.0;
    		transition: all 0.3s ease-in-out;
	}
	#workspaces button.active {
    		color: #${config.colorScheme.palette.base00};
    		background: #${config.colorScheme.palette.base04};
    		border-radius: 15px;
    		min-width: 40px;
    		transition: all 0.3s ease-in-out;
    		opacity: 1.0;
	}
	#workspaces button:hover {
    		color: #${config.colorScheme.palette.base00};
    		background: #${config.colorScheme.palette.base04};
    		border-radius: 15px;
    		opacity: 1.0;
	}
	tooltip {
  		background: #${config.colorScheme.palette.base00};
  		border: 1px solid #${config.colorScheme.palette.base04};
  		border-radius: 10px;
	}
	tooltip label {
  		color: #${config.colorScheme.palette.base07};
	}
	#window {
    		color: #${config.colorScheme.palette.base05};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 0px 15px 50px 0px;
    		margin: 5px 5px 5px 0px;
    		padding: 2px 20px;
	}
	#memory {
    		color: #${config.colorScheme.palette.base0F};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 15px 50px 15px 50px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#clock {
    		color: #${config.colorScheme.palette.base0B};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 15px 50px 15px 50px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#idle_inhibitor {
    		color: #${config.colorScheme.palette.base0A};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 50px 15px 50px 15px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#cpu {
    		color: #${config.colorScheme.palette.base0F};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 50px 15px 50px 15px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#disk {
    		color: #${config.colorScheme.palette.base03};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 15px 50px 15px 50px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#battery {
    		color: #${config.colorScheme.palette.base08};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 15px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#network {
    		color: #${config.colorScheme.palette.base09};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 50px 15px 50px 15px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#pulseaudio {
    		color: #${config.colorScheme.palette.base0D};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 50px 15px 50px 15px;
    		margin: 5px;
    		padding: 2px 20px;
	}
	#custom-notification {
    		color: #${config.colorScheme.palette.base0C};
    		background: #${config.colorScheme.palette.base00};
    		border-radius: 15px 50px 15px 50px;
    		margin: 5px;
    		padding: 2px 20px;
	}
    '';
        enable = true;
        settings = {
          "bar" = {
            layer = "top";
            position = "bottom";
            height = 50;
            width = null;
            exclusive = true;
            passthrough = false;
            spacing = 5;
            margin = null;
            fixed-center = true;
            ipc = false;

            modules-left = [ "hyprland/workspaces" "hyprland/language" ];
            modules-center = [ "clock" ];
            modules-right = [ 
              "network"
              "pulseaudio"
              "cpu"
              "memory"
            ];

            "hyprland/language" = {
              format = " {}";
            };

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
              format = "󰍛 {usage}%";
              interval = 2;
            };
            memory = {
              format = " {used:0.2f}G/{total:0.2f}G";
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
     wayland.windowManager.hyprland.settings = {
       windowrulev2 = [
         "forceinput,class:^(jetbrains-.*),title:^Select Methods to Override"
         "windowdance,class:^(jetbrains-.*)"
       ];

       bind = [
         "${mod},P,exec,${grimblastBin} --notify copy output"
         "${modshift}, P, exec, ${grimblastBin} --notify copy area"
         "${mod}, T, exec, foot"
         "${mod}, B, exec, chromium"
         "${mod}, C, killactive,"
         "${mod}, E, exec, nautilus"
         "${mod}, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
         "${mod}, S, exec, wofi --show drun"
         "${mod}, F, fullscreen"

         "${mod}, l, movefocus, l"
         "${mod}, h, movefocus, r"
         "${mod}, k, movefocus, u"
         "${mod}, j, movefocus, d"
         "${mod}, O, workspace, 1"
         "${mod}, N, workspace, 2"
         "${mod}, M, workspace, 3"

       ] ++ workspaces;

       bindm = [
         "${mod},mouse:272,movewindow"
         "${mod},mouse:273,resizewindow"
       ];

       exec-once = [
         "waybar"
         "mako"
         "hyprpaper"
         "wl-paste --type text --watch cliphist store"
         "wl-paste --type image --watch cliphist store"
       ];

       input = {

         kb_layout = "us,br";
         kb_options = "grp:alt_space_toggle,caps:swapescape";

         follow_mouse = 1;
         mouse_refocus = false;
       };

       general = {

         gaps_in = 5;
         gaps_out = 20;
         border_size = 2;
         "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
         "col.inactive_border" = "rgba(595959aa)";
       };

       decoration = {
         rounding = 6;
         drop_shadow = true;
         shadow_render_power = 3;
         "col.shadow" = "rgba(1a1a1aee)";
       };

       animations = {
         enabled = true;
       };

     };
    };
  }

