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
          python314
          python314Packages.python-lsp-server
			 python314Packages.pylint
          python314Packages.black
          python314Packages.isort
          python314Packages.mypy
          python314Packages.pytest
          python314Packages.ipython
        ];
      };
    });
}

