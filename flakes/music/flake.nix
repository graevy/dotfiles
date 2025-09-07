{
  description = "for processing music";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.kid3-cli
          pkgs.flacon
          pkgs.monkeysAudio
          pkgs.sox
        ];

	# flacon likes to write to `.config/flacon/`
	# why does flacon need state. also it inadvertently version-pins nixpkgs
	# anyway just give it a black hole to dump its state into
	shellHook = ''export XDG_CONFIG_HOME=$(mktemp -d)'';
      };
    };
}

