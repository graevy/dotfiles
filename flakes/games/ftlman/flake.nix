{
  description = "ftlman flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	 ftlman.url = "github:afishhh/ftlman";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ftlman, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            ftlman.packages.${system}.default
          ];

			shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.libGL
              pkgs.libglvnd
              pkgs.mesa
              pkgs.vulkan-loader
              pkgs.libxkbcommon
              pkgs.wayland
              pkgs.libX11
              pkgs.libXcursor
              pkgs.libXrandr
              pkgs.libXi
              pkgs.libxcb
              pkgs.libXcomposite
              pkgs.libXdamage
              pkgs.libXext
              pkgs.libXfixes
              pkgs.stdenv.cc.cc.lib
            ]}:$LD_LIBRARY_PATH"
            
            export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri"
            export __EGL_VENDOR_LIBRARY_DIRS="${pkgs.mesa}/share/glvnd/egl_vendor.d"
            export __GLX_VENDOR_LIBRARY_DIRS="${pkgs.mesa}/share/glvnd/glx_vendor.d"
          '';
        };
      }
    );
}

