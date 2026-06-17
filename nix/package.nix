# From nixpkgs pkgs/by-name/li/libverto/package.nix
# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/li/libverto/package.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  libev,
  libevent,
  pkg-config,
  glibSupport ? true,
  libevSupport ? true,
  libeventSupport ? true,
  version ? "0.3.3",
  # Note: nix/package.nix still has the fetchFromGitHub hash for the 0.3.2 tarball
  # that only matters when fetching upstream by tag, not for local src = self builds. 
  # Update the hash after we tag and push 0.3.3.
  src ? fetchFromGitHub {
    owner = "latchset";
    repo = "libverto";
    rev = version;
    hash = "sha256-csoJ0WdKyrza8kBSMKoaItKvcbijI6Wl8nWCbywPScQ=";
  },
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation {
  pname = "libverto";
  inherit version src;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    optional glibSupport glib ++ optional libevSupport libev ++ optional libeventSupport libevent;

  meta = {
    homepage = "https://github.com/latchset/libverto";
    description = "Asynchronous event loop abstraction library";
    longDescription = ''
      Libverto exists to solve an important problem: many applications and
      libraries are unable to write asynchronous code because they are unable to
      pick an event loop. This is particularly true of libraries who want to be
      useful to many applications who use loops that do not integrate with one
      another or which use home-grown loops. libverto provides a loop-neutral
      async api which allows the library to expose asynchronous interfaces and
      offload the choice of the main loop to the application.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
