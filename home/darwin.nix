{ pkgs, ... }:

{
  # home.username = "simmer";
  # home.homeDirectory = "/Users/simmer";

  home.packages = with pkgs; [
    btop
  ];

  programs = {
  };
}
