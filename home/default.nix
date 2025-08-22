# Shared home-manager configuration
{ pkgs, system, ... }:

let
  # Import platform-specific configuration based on system
  platformConfig =
    if pkgs.lib.hasSuffix "darwin" system then
      import ./darwin.nix { inherit pkgs; }
    else
      import ./nixos.nix { inherit pkgs; };
in
{
  home.username = "simmer";
  # Note: homeDirectory will be set by platform-specific files

  # Common packages for both platforms
  home.packages = with pkgs; [
    # Add your common packages here
  ];

  # Common programs configuration
  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  # Common home-manager settings
  home.stateVersion = "25.05";
}
// platformConfig
