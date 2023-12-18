{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:lopsided98/nixpkgs/nix-ros";
    flake-utils.url = "github:numtide/flake-utils";
    ros-overlay.url = "github:lopsided98/nix-ros-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, ros-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ros-overlay.overlays.default ];
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; with pkgs.rosPackages.humble; [
            (buildEnv {
              paths = [
                ament-cmake-core
		python-cmake-module
                ros-core
                vcstool
                colcon
              ];
            })
          ];
        };
      });
}
