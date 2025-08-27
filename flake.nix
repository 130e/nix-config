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
      username = "simmer";

      # Create nix-darwin system configuration
      mkDarwinSystem =
        { hostname, system }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit username inputs; };
          modules = [
            ./hosts/darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              # https://github.com/nix-community/home-manager/issues/6036
              users.users.${username}.home = "/Users/${username}";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username inputs; };
              home-manager.users.${username} = ./home/darwin.nix;
            }
          ];
        };

      # Create NixOS system configuration
      mkNixosSystem =
        {
          hostname,
          system,
          hardwareModules ? [ ],
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username inputs; };
          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username inputs; };
              home-manager.users.${username} = ./home/nixos.nix;
            }
          ]
          ++ hardwareModules
          ++ extraModules;
        };

    in
    {
      # Linux hosts
      nixosConfigurations = {
        "surface" = mkNixosSystem {
          hostname = "surface";
          system = "x86_64-linux";
          hardwareModules = [
            nixos-hardware.nixosModules.microsoft-surface-go
          ];
          extraModules = [
            ./hosts/nixos/surface
          ];
        };
      };

      # Darwin hosts
      darwinConfigurations = {
        "minicube" = mkDarwinSystem {
          hostname = "minicube";
          system = "x86_64-darwin";
        };
        "pro4port" = mkDarwinSystem {
          hostname = "pro4port";
          system = "x86_64-darwin";
        };
      };

    };
}
