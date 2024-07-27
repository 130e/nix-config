{
  pkgs,
  config,
  ...
}: {
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
      (writeShellScriptBin "hyprmontoggle" (builtins.readFile ./hypr/hyprmontoggle.sh)) # Scrcipt for toggling monitor
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

  # for reference on hyprland
  # https://github.com/donovanglover/nix-config/blob/master/home/hyprland.nix
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
    settings = {
      monitor = [
        "eDP-1,preferred,auto,1"
        ",preferred,auto,auto"
      ];
      env = [ "XDG_PICTURES_DIR,$HOME/Picture/Screenshot" ];
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun -I";
      "$chromium-browser" = "brave";
      "$gecko-browser" = "librewolf";
      exec-once = [
        "waybar"
        "swww-daemon"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "[workspace 1 silent] $terminal"
        "[workspace 2 silent] $chromium-browser"
        "[workspace 10 silent] $terminal --hold bash -c 'btop'"
        "[workspace special:magic silent] telegram-desktop"
        "[workspace special:magic silent] slack"
      ];
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod SHIFT, T, exec, hyprmontoggle"

        "$mainMod, Return, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, D, exec, $gecko-browser"
        "$mainMod, B, exec, $chromium-browser"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
        "float,class:^(chromium)$"
        "float,class:^([tT]hunar)$"
        "float,class:^(librewolf)$,title:^(Library)$"
        "float,class:^(fcitx5-config.*)$"
        "float,class:^(.*blueman-manager.*)$"
        "float,class:^(.*qpwgraph)$"
        "float,class:^(pavucontrol)$"
        "float,initialClass:^(mpv)$"
        "float,class:^([sS]lack)$"
        "float,class:^(.telegram-desktop-wrapped)$"
        "float,class:^(org.telegram.desktop)$"
      ];
    };
  };

  # End of nix file
}
