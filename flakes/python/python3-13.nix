{
  description = "generic python 3.13 dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          python313
          python313Packages.python-lsp-server
			 python313Packages.pylint
          python313Packages.black
          python313Packages.isort
          python313Packages.mypy
          python313Packages.pytest
          python313Packages.ipython
        ];
      };
    });
}

