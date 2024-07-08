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

  # Custom programs
  # ----------------------------
  gtk = {
    enable = true;
    # gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    theme = {
      # Dark theme
      # name = "Kanagawa-BL";
      # Light theme
      name = "vimix-light-doder";
    };
    iconTheme = {
      # name = "Kanagawa";
      name = "Vimix-Doder";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      wl-clipboard
      unzip
      python3
      nodejs
      gcc
      gnumake
      cargo
      deadnix
      statix
    ];
  };

  # Based on nvchad nixos port
  # https://codeberg.org/daniel_chesters/nvchad_config
  xdg.configFile.nvim = {
    # source = inputs.nvchad-config;
    source = ./nvchad_config;
    recursive = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };
    # Allow dynamic changing themes
    extraConfig = "include ./current-theme.conf";
    # theme = "Kanagawa"; # ReadOnly conf
  };

  # Input
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool
      ];
    };
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
        monitor=eDP-1,preferred,auto,1.25
        monitor=,preferred,auto,auto,mirror,eDP-1
        env = XDG_PICTURES_DIR,$HOME/Picture/Screenshot
        ${builtins.readFile ./hypr/hyprland.conf}
      '';
  wayland.windowManager.hyprland.settings = {
    # TODO
  };
  # for reference on hyprland
  # https://github.com/donovanglover/nix-config/blob/master/home/hyprland.nix

  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };

  services.dunst = {
    enable = true;
    configFile = "$XDG_CONFIG_HOME/dunst/dunstrc";
  };

  xdg.configFile.dunst = {
    # source = inputs.nvchad-config;
    source = ./dunst;
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
        # all my laptop seems to be using hardware-managed kbd_backlight
        # { 
        #   timeout = 150;                                          # 2.5min.
        #   on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";  # turn off keyboard backlight.
        #   on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
        # }
        
        {
          timeout = 600;                                 # 10min
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
  programs.hyprlock.extraConfig = builtins.readFile ./hypr/hyprlock.conf;

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

  # Services
  # -------------------------------
  services.syncthing.enable = true;

  home.packages = with pkgs; [
    neofetch

    # archive
    zip
    unzip
    xz

    # utils
    ripgrep
    tree
    htop
    bc
    unrar
    ffmpeg

    # gui apps
    hyprshot
    hyprcursor
    libnotify
    swww
    xfce.thunar
    keepassxc
    brightnessctl
    ungoogled-chromium # TODO: config it properly
    telegram-desktop
    slack
    steam-run
    # themes
    kanagawa-gtk-theme
    kanagawa-icon-theme
    vimix-gtk-themes
    vimix-icon-theme
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
