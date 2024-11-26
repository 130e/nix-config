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
}
