# NixOS ISOs with Determinate Nix

This repo houses the build logic for [Determinate Systems][detsys]' official ISO for [NixOS].
Our ISOs are available for these systems:

| System        | Nix system name |
| :------------ | :-------------- |
| x86 Linux     | `x86_64-linux`  |
| aarch64 Linux | `aarch64-linux` |

You can download the ISOs at these addresses:

| System        | URL                                                                |
| :------------ | :----------------------------------------------------------------- |
| x86_64 Linux  | https://install.determinate.systems/nixos-iso/stable/x86_64-linux  |
| aarch64 Linux | https://install.determinate.systems/nixos-iso/stable/aarch64-linux |

On both systems, the ISOs have these tools installed:

- [Determinate Nix][det-nix], Determinate Systems' validated and secure [Nix] distribution for enterprises.
  This includes [Determinate Nixd][dnixd], a utility that enables you to log in to [FlakeHub] using only this command (amongst other tasks):

  ```shell
  determinate-nixd login
  ```

  Once logged in, your host can access [FlakeHub Cache][cache] and [private flakes][private-flakes] for your organization.

- [fh], the CLI for [FlakeHub].
  You can use fh for things like [applying][fh-apply-nixos] NixOS configurations uploaded to [FlakeHub Cache][cache].
  Here's an example:

  ```shell
  determinate-nixd login
  fh apply nixos "my-org/my-flake/*#nixosConfigurations.my-nixos-configuration-output"
  ```

> [!NOTE]
> This NixOS installer image is identical to NixOS's ISOs, but with two important differences:
> 1. Flakes are enabled by default via Determinate Nix
> 2. NetworkManager is enabled instead of bare WPA Supplicant.

[ami]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html
[fh-apply-nixos]: https://docs.determinate.systems/flakehub/cli#apply-nixos
[cache]: https://docs.determinate.systems/flakehub/cache
[demo]: https://github.com/determinatesystems/demo
[det-nix]: https://docs.determinate.systems/determinate-nix
[detsys]: https://determinate.systems
[dnixd]: https://docs.determinate.systems/determinate-nix#determinate-nixd
[ec2]: https://aws.amazon.com/ec2
[fh]: https://docs.determinate.systems/flakehub/cli
[fh-apply]: https://docs.determinate.systems/flakehub/cli#apply
[flakehub]: https://flakehub.com
[nix]: https://docs.determinate.systems/determinate-nix
[nixos]: https://zero-to-nix.com/concepts/nixos
[opentofu]: https://opentofu.org
[private-flakes]: https://docs.determinate.systems/flakehub/private-flakes
[ssm]: https://aws.amazon.com/systems-manager
[sts]: https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html
[terraform]: https://terraform.io
