{ 
  inputs,
  ...
}: let
  user = "simmer";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "EnvySea"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs = {
    # NOTE: Required by Hyprland
    hyprland.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    wireshark.enable = true;
  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "wireshark"];
    };
  };

}
