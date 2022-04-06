{
  description = "Lapce flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      overlay = final: prev: let
        pkgs = nixpkgs.legacyPackages.${prev.system};
      in rec {
        lapce = pkgs.lapce-unwrapped.overrideAttrs (oa: {
          version = "master";
          src = ../.;
        });
      };
    }
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        overlays = [self.overlay];
        inherit system;
      };
    in rec {
      package = with pkgs; {
        inherit lapce;
      };

      defaultPackage = pkgs.lapce;
      app = {
        lapce = flake-utils.lib.mkApp {
          drv = pkgs.lapce;
          name = "lapce";
        };
      };
      defaultApp = app.lapce;
    });
}
