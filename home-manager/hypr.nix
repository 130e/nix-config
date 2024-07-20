{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
    settings = {
      monitor = [
        "eDP-1,preferred,auto,1"
        ",preferred,auto,auto"
      ];
      env = [ "XDG_PICTURES_DIR,$HOME/Picture/Screenshot" ];
      exec-once = [
        "waybar"
        "swww-daemon"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "[workspace 1 silent] kitty"
        "[workspace 2 silent] qutebrowser"
        "[workspace 3 silent] librewolf"
        "[workspace 10 silent] kitty --hold bash -c 'btop'"
      ];
    };
  };
  # for reference on hyprland
  # https://github.com/donovanglover/nix-config/blob/master/home/hyprland.nix

  programs = {
    waybar.enable = true;
    wofi.enable = true;
    hyprlock = {
      enable = true;
      extraConfig = builtins.readFile ./hypr/hyprlock.conf;
    };
  };

  home = {
    packages = with pkgs; [
      hyprshot
      hyprcursor
      libnotify
    ];
  };

  xdg.configFile = {
    dunst = {
      # source = inputs.nvchad-config;
      source = ./dunst;
      recursive = true;
    };

    waybar = {
      source = ./waybar;
      recursive = true;
    };
  };

  services = {
    dunst = {
      enable = true;
      configFile = "$XDG_CONFIG_HOME/dunst/dunstrc";
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
            lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
            before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
            after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 150;                                 # 2.5min.
            on-timeout = "brightnessctl -s set 10";        # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r";                # monitor backlight restore.
          }
          
          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          # all my laptop seems to be using hardware-managed kbd_backlight
          # { 
          #   timeout = 150;                                          # 2.5min.
          #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";  # turn off keyboard backlight.
          #   on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
          # }
          
          {
            timeout = 300;                                 # 5min
            on-timeout = "hyprctl dispatch dpms off";      # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on";        # screen on when activity is detected after timeout has fired.
          }
          
          {
            timeout = 600;                                 # 10min
            on-timeout = "loginctl lock-session";          # lock screen when timeout has passed
          }
          
          {
            timeout = 1800;                                # 30min
            on-timeout = "systemctl suspend";              # suspend pc
          }

          {
            timeout = 1800;                                # 30min
            on-timeout = "systemctl suspend";              # suspend pc
          }
        ];
      };
    };

  # End of services
  };
  # End of nix file
}
