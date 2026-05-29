# flake.nix
{
  description = "xmr devShell provides `mine [intensity]` (0-100)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mine = pkgs.writeShellApplication {
        name = "mine";
        runtimeInputs = [ pkgs.xmrig ];
        text = ''
          intensity=''${1:-50}
          address=''${XMR_ADDRESS}
          pool=''${XMR_POOL}

          if [[ -z "$address" ]]; then
            echo "error: $XMR_ADDRESS unset" >&2
            exit 1
          fi

			 if [[ -z "$pool" ]]; then
			   echo "error: $XMR_POOL unset" >&2
				exit 1
			 fi

          if [[ "$intensity" -lt 0 || "$intensity" -gt 100 ]]; then
            echo "error: intensity must be 0–100" >&2
            exit 1
          fi

          echo "starting xmrig: pool=$pool intensity=$intensity%"
          exec xmrig \
            --url "$pool" \
            --user "$address" \
            --pass "nixos-rig" \
            --coin monero \
            --cpu-max-threads-hint "$intensity" \
            --http-host 127.0.0.1 \
            --http-port 3334 \
            --donate-level 1 \
            --randomx-init 1
        '';
      };

    in {
      packages.${system}.mine = mine;
      packages.${system}.default = mine;

      devShells.${system}.default = pkgs.mkShell {
        packages = [ mine pkgs.xmrig ];
        shellHook = ''
          echo ""
          echo "  mine [intensity]   start mining (intensity 0-100, default 50)"
          echo "  mine 80            high heat mode"
          echo "  mine 20            background trickle"
          echo ""
          echo "  stats via:  curl -s http://127.0.0.1:3334/2/summary | jq"
          echo ""
        '';
      };
    };
}

