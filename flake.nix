{
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  inputs.fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

  outputs =
    {
      self,
      determinate,
      nixpkgs,
      fh,
      ...
    }:
    let
      forSystems =
        s: f:
        nixpkgs.lib.genAttrs s (
          system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      forAllSystems = forSystems [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forLinuxSystems = forSystems [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      devShells = forAllSystems (
        { system, pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              nixfmt-rfc-style
            ];
          };
        }
      );

      packages = forLinuxSystems (
        { system, ... }:
        {
          toplevel = self.nixosConfigurations.${system}.install.config.system.build.toplevel;
          iso = self.nixosConfigurations.${system}.install.config.system.build.isoImage;
        }
      );

      nixosConfigurations = forLinuxSystems (
        { system, ... }:
        {
          install = nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              # Load the Determinate module
              determinate.nixosModules.default
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-combined.nix"
              (
                {
                  options,
                  pkgs,
                  lib,
                  ...
                }:
                {
                  environment.systemPackages = [ fh.packages.${pkgs.stdenv.hostPlatform.system}.default ];
                  environment.etc."nixos/flake.nix" = {
                    source = ./flake.nix;
                    mode = "0644";
                  };
                  environment.etc."nixos/flake.lock" = {
                    source = ./flake.lock;
                    mode = "0644";
                  };
                  environment.etc."nixos-generate-config.conf".text = ''
                    [Defaults]
                    Flake=1
                  '';

                  networking.wireless.enable = lib.mkForce false;
                  networking.networkmanager.enable = true;

                  system.nixos-generate-config.flake = ''
                    {
                      inputs = {
                        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
                        nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # NixOS, rolling release
                        # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0"; # NixOS, current stable
                      };
                      outputs = inputs\@{ self, nixpkgs, determinate, ... }: {
                        # NOTE: '${options.networking.hostName.default}' is the default hostname
                        nixosConfigurations.${options.networking.hostName.default} = nixpkgs.lib.nixosSystem {
                          modules = [
                            determinate.nixosModules.default
                            ./configuration.nix
                          ];
                        };
                      };
                    }
                  '';
                }
              )
            ];
          };
        }
      );
    };
}
