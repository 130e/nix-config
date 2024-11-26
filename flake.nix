# Flake config
# Glue NixOS and home-manager together
# Manage hosts
{
  description = "Nixos config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      # sudo nixos-rebuild switch --flake ~/nix-config#EnvySea --option eval-cache false --show-trace
      nixosConfigurations = {
        # NOTE: replace with your hostname
        EnvySea = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/EnvySea
            ./nixos/configuration.nix
            ./nixos/nixos-desktop.nix
          ];
        };

        Surface = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/Surface
            ./nixos/configuration.nix
            ./nixos/nixos-desktop.nix
          ];
        };

        Bowl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/Bowl
            ./nixos/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # home-manager switch --flake ~/nix-config#simmer@EnvySea --option eval-cache false --show-trace
      homeConfigurations = {
        # NOTE: replace with your username@hostname
        "simmer@EnvySea" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/simmer.nix
            ./home-manager/home.nix
            ./home-manager/desktop.nix
          ];
        };

        "simmer@Surface" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home-manager/simmer.nix
            ./home-manager/home.nix
            ./home-manager/desktop.nix
          ];
        };

        # Used by home-manager to install a user headless environment
        # NOTE: sample user.nix
        # { inputs, pkgs, ...}:
        # {
        #   home = {
        #     username = "simmer";
        #     homeDirectory = "/home/simmer";
        #   };
        # }
        "user" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home-manager/user.nix # NOTE: create this
            ./home-manager/home.nix
          ];
        };
      };
    };
}
