{
  description = "libverto - asynchronous event loop abstraction library";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs systems;
      version =
        let
          cfg = builtins.readFile ./configure.ac;
          m = builtins.match ".*AC_INIT\\([^,]+, ([^)]+)\\).*" cfg;
        in
        nixpkgs.lib.removePrefix " " (nixpkgs.lib.elemAt m 0);
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          libverto = pkgs.callPackage ./nix/package.nix {
            inherit version;
            src = self;
          };
        in
        {
          inherit libverto;
          default = libverto;
        }
      );

      checks = forAllSystems (
        system:
        {
          default = self.packages.${system}.default;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            packages = with pkgs; [
              autoconf
              automake
              libtool
              pkg-config
              glib
              libev
              libevent
              gcc
              gnumake
            ];
          };
        }
      );
    };
}
