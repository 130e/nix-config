# Shared home-manager configuration
{ pkgs, ... }:

{
  home.username = "simmer";
  
  # Common packages
  home.packages = with pkgs; [
  ];

  # Common programs configuration
  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  programs.kakoune = {
    enable = true;
    defaultEditor = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  # Common home-manager settings
  home.stateVersion = "25.05";
}
