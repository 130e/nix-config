# Why flake?
# Glue NixOS and home-manager together
# Pin package versions
# Easier for multiple machines
{
  description = "Nix config for Bootstrapping";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # For specific hardware fix
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # For mac darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Make home-manager reuse the same nixpkgs input
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      nix-darwin,
      home-manager,
    }@inputs:
    let
      user = "simmer";
    in
    {
      # Linux hosts
      nixosConfigurations = {
        # Surface
        "surface" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos-x86/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-go
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = { pkgs, ... }: {
                imports = [
                  ./home/default.nix
                  ./home/nixos.nix
                ];
              };
            }
          ];
        };
      };

      # Darwin hosts
      darwinConfigurations = {
        # Mac mini 2014
        "minicube" = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./hosts/darwin-x86/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = { pkgs, ... }: {
                imports = [
                  ./home/default.nix
                  ./home/darwin.nix
                ];
              };
            }
          ];
        };
      };

    };
}
