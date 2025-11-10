{
  description = "generic go dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          go_1_25
          gopls
          delve
          protobuf
        ];

        shellHook = ''
          export GOPATH=$HOME/go
          export PATH=$GOPATH/bin:$PATH
        '';
      };
    });
}

