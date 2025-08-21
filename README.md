# fabric-servers-overlay

A flake which directly exposes the changes of [this PR](https://github.com/NixOS/nixpkgs/pull/432803).

This flake exposes:

- an overlay which you can apply to your very own `nixpkgs`
- packages for each version (uses `nixpkgs-unstable` by default)

The overlay provides packages under `pkgs.fabricServers`. Packages are named
like this: `fabric-<game version>` (where `<game-version>` is `1_21_8`, `1_21`,
etc). The flake exposes the packages of the overlay using a pinned `nixpkgs`.
