{
  description = "for processing music";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          ffmpeg
          kid3-cli
          flacon
          monkeysAudio
          sox
        ];

        # flacon likes to write to `.config/flacon/`
        # why does flacon need state. also it inadvertently version-pins nixpkgs
        # anyway just give it a black hole to dump its state into
        shellHook = ''export XDG_CONFIG_HOME=$(mktemp -d)'';
      };
    });
}

