{ pkgs, ... }:

{
  home.homeDirectory = "/home/simmer";

  # Linux-specific packages
  home.packages = with pkgs; [
    # Add Linux-specific packages here
    # Example: xorg packages, desktop environment packages, etc.
  ];

  # Linux-specific programs
  programs = {
    # Add Linux-specific program configurations here
  };
}
