{
  description = "generic lua dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
		  nativeBuildInputs = with nixpkgs.legacyPackages.${system}; [
          gcc 
        ];
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          lua
			 luajit
			 lua-language-server
		  ];
      };
    });
}

