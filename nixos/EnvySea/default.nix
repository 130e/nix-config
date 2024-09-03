{ 
  inputs,
  ...
}: let
  user = "simmer";
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
