# Desktop environment setup
{
  inputs,
  pkgs,
  ...
}:
{
  # Programs
  environment = {
    systemPackages = with pkgs; [
      # Utilities intsall syswide
      wireshark
      pkgs.gnomeExtensions.im-panel-integrated-with-osk
      pkgs.gnomeExtensions.kimpanel
    ];
    # Force app to use wayland; doesn't work most of time
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  # Display environment
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # programs = {
  #   hyprland.enable = true; # Required by Hyprland
  # };
  # security = {
  #   pam.services.hyprlock = { }; # Enable hyprlock to use PAM
  # };

  # Conflict with gnome

  # Power
  # services.tlp.enable = true;

  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #     governor = "powersave";
  #     turbo = "never";
  #   };
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  # };
}
