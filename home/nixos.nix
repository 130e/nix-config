{ pkgs, ... }:

{
  home.homeDirectory = "/home/simmer";

  # Linux-specific packages
  home.packages = with pkgs; [
    # Add Linux-specific packages here
  ];

  # Linux-specific programs
  programs = {
    # Add Linux-specific program configurations here
  };
}
