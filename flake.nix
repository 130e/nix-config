{
  description = "My weird Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvchad
    # nvchad-config = {
    #   url = "git+https://codeberg.org/daniel_chesters/nvchad_config";
    #   flake = false;
    # };

    # rice
    # nixvim.url = "github:elythh/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      EnvySea = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./nixos/EnvySea/configuration.nix

          # home-manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.oar = import ./home-manager/oar.nix;
              # Optionally, use home-manager.extraSpecialArgs to pass
              # TODO: why have to use inherit
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      IcySurface = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/IcySurface/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.tila = import ./home-manager/tila.nix;
              # Optionally, use home-manager.extraSpecialArgs to pass
              # TODO: why have to use inherit
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
