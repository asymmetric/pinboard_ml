{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    let
      package = "pinboard_ml";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # packages.default = pkgs.legacyPackages.${system}.${package};

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            libev
            ocaml
            ocamlPackages.ocamlformat
            pkg-config
            openssl
            sqlite
            gmp
          ];
        };
      }
    );
}
