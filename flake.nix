{
  inputs.nixpkgs.url = "github:determinatesystems/nixpkgs/installer";
  inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*"; # */

  outputs = { self, determinate, nixpkgs, ... }: {
    packages.x86_64-linux.toplevel = self.nixosConfigurations.install.config.system.build.toplevel;
    packages.x86_64-linux.iso = self.nixosConfigurations.install.config.system.build.isoImage;

    nixosConfigurations.install = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Load the Determinate module
        determinate.nixosModules.default
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-combined.nix"
        ({ options, ... }: {
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
        determinate.nixosModule.default
        ./configuration.nix
      ];
    };
  };
}
'';
        })
      ];
    };
  };


}