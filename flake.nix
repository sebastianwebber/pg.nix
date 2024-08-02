{
  description = "PostgreSQL on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      targetSystems = with flake-utils.lib.system; [
        x86_64-linux
        aarch64-linux
      ];
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        ## TODO: move to a module!

        ## set pg version here
        postgres = pkgs.postgresql_16;

        # TODO: fix patroni setup on darwin
        allPkgs = with pkgs; [ postgres pg_activity htop jq just ];

        imgCfg = {
          name = "docker.io/pg/test";
          tag = "latest";
        };
      in {

        # use the command below to inspect the image:
        #   docker load < result && dive docker.io/pg/test:latest
        packages = {
          default = pkgs.dockerTools.buildImage {
            name = imgCfg.name;
            tag = imgCfg.tag;

            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              pathsToLink = [ "/bin" ];
              paths = allPkgs;
            };
            created = "now";

            config = { };
          };

          multilayer = pkgs.dockerTools.buildLayeredImage {
            name = imgCfg.name;
            tag = imgCfg.tag;

            contents = allPkgs;
            created = "now";

            config = { };
          };
        };

        ## nix develop
        devshell.default = pkgs.mkShell { buildInputs = allPkgs; };
      });
}
