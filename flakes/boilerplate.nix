{
	description = "generic dev flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
				# if you're into this sort of thing
				# pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
			in
			{
				devShells.default = pkgs.mkShell {
					nativeBuildInputs = with pkgs; [
					 
					];
					buildInputs = with pkgs; [

					];

					shellHook = ''

					'';
				};
			});
}

