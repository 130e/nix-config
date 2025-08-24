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
    in
    {
      # Linux hosts
      nixosConfigurations = {

        "surface" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit username inputs; };
          modules = [
            ./hosts/nixos-x86/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-go
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username inputs; };
              home-manager.users.${username} = ./home/nixos.nix;
            }
          ];
        };
        
      };

      # Darwin hosts (x86)
      darwinConfigurations = {

        "minicube" = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          specialArgs = { inherit username inputs; };
          modules = [
            ./hosts/darwin-x86/configuration.nix
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

      };

    };
}
