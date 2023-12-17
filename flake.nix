{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ros-overlay.url = "github:lopsided98/nix-ros-overlay/e3eba7bb67e60108ba22ce297d72e1a9ad71311f";
  };

  outputs = { self, nixpkgs, flake-utils, ros-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system; 
	overlays = [ ros-overlay.overlays.default ];
      }; in {

        devShell = pkgs.mkShell {
	  buildInputs = with pkgs; with rosPackages.humble; [
	    cmake
	    ros-core
	  ];
        };
      });
}
