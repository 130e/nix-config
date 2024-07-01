# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  # TODO: Set your username
  home = {
    username = "tila";
    homeDirectory = "/home/tila";
  };

  # Custom programs
  # ----------------------------
  programs.neovim.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };
  };

  # Input
  # TODO: if doesn't start, check https://nixos.wiki/wiki/Fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-configtool
        fcitx5-chinese-addons
      ];
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./dotfile/hypr/hyprland.conf;
  # for reference on hyprland
  # https://github.com/donovanglover/nix-config/blob/master/home/hyprland.nix

  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = ./dotfile/waybar;
    recursive = true;
  };

  programs.wofi.enable = true;

  services.hypridle = {
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
        #{ 
        #  timeout = 150                                          # 2.5min.
        #  on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
        #  on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
        #}
        
        {
          timeout = 300;                                 # 5min
          on-timeout = "loginctl lock-session";          # lock screen when timeout has passed
        }
        
        {
          timeout = 330;                                 # 5.5min
          on-timeout = "hyprctl dispatch dpms off";      # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on";        # screen on when activity is detected after timeout has fired.
        }
        
        {
          timeout = 1800;                                # 30min
          on-timeout = "systemctl suspend";              # suspend pc
        }
      ];
    };
  };

  programs.hyprlock.enable = true;
  programs.hyprlock.extraConfig = builtins.readFile ./dotfile/hypr/hyprlock.conf;

  programs.firefox.enable = true;
  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };

  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  services.syncthing.enable = true;

  home.packages = with pkgs; [
    neofetch

    # archive
    zip
    xz

    # utils
    ripgrep
    tree
    htop

    xfce.thunar
    keepassxc
    brightnessctl
    ungoogled-chromium # TODO: config it properly
    telegram-desktop
    slack
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
