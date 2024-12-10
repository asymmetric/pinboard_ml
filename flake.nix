{
  inputs = {
    dune-flake.url = "github:ocaml/dune";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      dune-flake,
      flake-utils,
      nixpkgs,
    }:
    let
      package = "pinboard_ml";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          dune-flake.overlays.default
        ];
      in
      {
        # packages.default = pkgs.legacyPackages.${system}.${package};

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            dune
            gmp
            libev
            ocaml
            ocamlPackages.ocamlformat
            ocamlPackages.utop
            openssl
            pkg-config
            sqlite.dev # needed for dune build
          ];
        };
      }
    );
}
