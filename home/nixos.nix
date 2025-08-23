{ pkgs, ... }:

{
  home.homeDirectory = "/home/simmer";

  home.packages = with pkgs; [
  ];

  programs = {
  };
}
