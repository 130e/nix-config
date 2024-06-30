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

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;
  # for reference on hyprland
  # https://github.com/donovanglover/nix-config/blob/master/home/hyprland.nix

  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = dotfile/waybar;
    recursive = true;
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  home.packages = with pkgs; [
    neofetch

    # archive
    zip
    xz

    # utils
    ripgrep
    tree
    htop
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
