{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
  };
  outputs = { self, flake-utils, opam-nix, nixpkgs }@inputs:
    let package = "pinboard_ml";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};
        scope =
          on.buildOpamProject { } package ./. { ocaml-base-compiler = "4.14.1"; };
        overlay = final: prev:
          {
            # Your overrides go here
          };
      in
      {
        legacyPackages = scope.overrideScope' overlay;

        packages.default = self.legacyPackages.${system}.${package};

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            dune_3
            libev
            ocaml
            ocamlformat
            opam
            pkg-config
            openssl
            sqlite-interactive
          ];
        };
      });
}
