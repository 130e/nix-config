{ 
  inputs,
  ...
}: let
  user = "oar"; # Giant oarfish
in {
  imports = [
    ./hardware-configuration.nix
  ];

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "wireshark"];
    };
  };
}
