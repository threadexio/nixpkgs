{
  description = "An overlay implementing https://github.com/threadexio/nixpkgs/tree/fabric-servers.";

  # Override this as needed.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      inherit (nixpkgs) lib;

      perSystem = f: lib.genAttrs systems f;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

      perSystemPkgs = f: perSystem (system: f (mkPkgs system));
    in
    {
      overlays.default = final: _: {
        fabricServers = import ./pkgs/games/fabric-servers { inherit (final) callPackage lib; };
      };

      packages = perSystemPkgs (
        pkgs:
        {
          default = self.packages.${pkgs.system}.fabric;
        }
        // lib.filterAttrs (name: _: lib.hasPrefix "fabric" name) pkgs.fabricServers
      );

      apps = perSystem (
        system:
        {
          default = self.apps.${system}.fabric;
        }
        // lib.mapAttrs (_: package: {
          type = "app";
          program = lib.getExe package;
        }) self.packages.${system}
      );

      formatter = perSystemPkgs (pkgs: pkgs.nixpkgs-fmt);
    };
}
