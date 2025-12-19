{
  description = "generic java dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
           jdk25_headless
			  jdt-language-server
			  # maven/gradle go here
        ];

        shellHook = ''
          export JAVA_HOME="${pkgs.jdk21}"
        '';
      };
    });
}

