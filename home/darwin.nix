{ pkgs, ... }:

{
  home.homeDirectory = "/Users/simmer";

  # macOS-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
  ];

  # macOS-specific programs
  programs = {
    # Add macOS-specific program configurations here
  };
}
