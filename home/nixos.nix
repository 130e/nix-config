{ username, ... }:

{
  # Other modules
  imports = [ ./core.nix ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Common home-manager settings
  home.stateVersion = "25.05";
}
