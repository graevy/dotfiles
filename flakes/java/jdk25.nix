{
	description = "generic java dev flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
	flake-utils.lib.eachDefaultSystem (system:
	let
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		devShells.default = pkgs.mkShell {
			buildInputs = [
				pkgs.jdk25_headless
				pkgs.jdt-language-server
				# maven/gradle go here
			];

			shellHook = ''
				export JAVA_HOME="${pkgs.jdk25_headless}"
			'';
			};
		}
	);
}

