{ username, ... }:

{
  # Other modules
  imports = [
    ./core.nix
    ./desktop.nix
    ./personal.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Common home-manager settings
  home.stateVersion = "25.05";
}
