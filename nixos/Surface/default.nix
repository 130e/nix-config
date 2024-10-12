# EnvySea
# My main laptop with touch screen
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Surface"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs = {
    hyprland.enable = true; # Required by Hyprland
    steam = {
      enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };

  security = {
    pam.services.hyprlock = { }; # Enable hyprlock to use PAM
  };

  # Power
  services.tlp.enable = true;
}
