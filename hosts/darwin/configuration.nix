# Additional parameters for this machine
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  programs.bash = {
    enable = true;
    completion.enable = true;
  };

  # Setuid apps
  # ws not supported by nix-darwin
  # programs = {
  #   wireshark = {
  #     enable = true;
  #     usbmon.enable = true;
  #   };
  # };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
