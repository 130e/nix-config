{ pkgs, ... }:

{
  home.username = "simmer";
  home.homeDirectory = "/home/simmer";

  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  home.stateVersion = "25.05"; # separate from system.stateVersion
}
