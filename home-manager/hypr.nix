# home-manager user environment if using Hyprland
# NOTE: Hyprland also need to be configured in NixOS configuration
{ pkgs, config, ... }:
{
  programs = {
    waybar.enable = true;
    hyprlock = {
      enable = true;
      extraConfig = builtins.readFile ../dotfiles/hypr/hyprlock.conf;
    };
  };

  home = {
    packages = with pkgs; [
      xdg-utils
      rofi-wayland
      swww
      brightnessctl
      hyprcursor
      libnotify
      # (writeShellScriptBin "hyprmontoggle" (builtins.readFile ./hypr/hyprmontoggle.sh))
      grim
      slurp
      grimblast
      swappy
    ];
  };

  xdg.configFile = {
    "rofi" = {
      source = ../dotfiles/rofi;
      recursive = true;
    };
    "dunst" = {
      source = ../dotfiles/dunst;
      recursive = true;
    };
    "waybar" = {
      source = ../dotfiles/waybar;
      recursive = true;
    };
    "hypr/hyprmontoggle".source = ../dotfiles/hypr/hyprmontoggle;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../dotfiles/hypr/hyprland.conf;
  };

  # TODO: hypridle doesn't work properly if started manually as systemd service
  # So use HM options to configure
  services = {
    # General
    network-manager-applet.enable = true; # nm gui
    blueman-applet.enable = true; # bluetooth gui
    mpris-proxy.enable = true; # earbud control
    playerctld.enable = true; # media key

    dunst = {
      enable = true;
      configFile = "$XDG_CONFIG_HOME/dunst/dunstrc";
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 300; # 5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }

          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          # all my laptop seems to be using hardware-managed kbd_backlight
          # {
          #   timeout = 150;                                          # 2.5min.
          #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";  # turn off keyboard backlight.
          #   on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
          # }

          {
            timeout = 360; # 6min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = 900; # 15min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }

          {
            timeout = 7200; # 2hr
            on-timeout = "systemctl hibernate"; # hibernate
          }
        ];
      };
    };

    # End of services
  };

  # End of nix file
}
