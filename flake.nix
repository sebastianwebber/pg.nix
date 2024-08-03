{
  description = "PostgreSQL on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs:
    let
      nodes = {
        "db-node-1" = { hostId = "00000001"; };
        "db-node-2" = { hostId = "00000002"; };
      };
    in {
      nixosConfigurations = builtins.listToAttrs (map (name: {
        name = name;
        value =
          let nodeConfig = nodes.${name};
          in nixpkgs.lib.nixosSystem {
            specialArgs = { meta = { hostname = name; }; };
            system = "aarch64-linux";
            modules = [
              disko.nixosModules.disko
              ./host-config/disko.nix
              ./host-config/configuration.nix
              {
                networking.hostName = name;
                networking.hostId = nodeConfig.hostId;
                system.stateVersion = "24.05";
              }
              ./host-config/setup.nix
            ];
          };
      }) (builtins.attrNames nodes));
    };
}
