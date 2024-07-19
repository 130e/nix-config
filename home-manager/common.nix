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
    ./desktop.nix
  ];

  # Custom programs
  # ----------------------------
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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      size = 11;
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      confirm_os_window_close = 0;
      shell = "fish";
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    # Allow dynamic changing themes
    extraConfig = "include ./current-theme.conf";
  };

  programs.btop.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = "kitty";
    };
  };

  # Input
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool
          fcitx5-gtk
          fcitx5-tokyonight
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    # for some reason this option is read only in direnv
    # and always set true
    # enableFishIntegration = true;
  };

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      l = "ls -ahl";
      ll = "ls -l";
      hypredpoff = "hyprctl keyword monitor eDP-1,disable";
      hypredpon = "hyprctl keyword monitor eDP-1,preferred,auto,auto";
      hypredpmirror = "hyprctl keyword monitor HDMI-A-1,preferred,auto,auto,mirror,eDP-1";
    };
  };

  # https://wiki.nixos.org/wiki/MPV
  programs.mpv = {
    enable = true;
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
    p7zip

    # utils
    ripgrep
    tree
    bc
    unrar-free
    ffmpeg

    # Fun stuff
    # TODO: auto download piper sound resources 
    # https://github.com/rhasspy/piper
    piper-tts
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
