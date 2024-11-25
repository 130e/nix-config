# Surface go 2
# Tablet
{ inputs, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "Surface"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # programs = {
  #   hyprland.enable = true; # Required by Hyprland
  # };
  # security = {
  #   pam.services.hyprlock = { }; # Enable hyprlock to use PAM
  # };

  # Display environment
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  # Power
  # services.tlp.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
