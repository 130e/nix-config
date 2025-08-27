{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "surface";
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # programs = {
  #   hyprland.enable = true; # Required by Hyprland
  # };

  # security = {
  #   pam.services.hyprlock = { }; # Enable hyprlock to use PAM
  # };

  # Power
  # services.tlp.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

}
