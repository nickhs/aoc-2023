{
  description = "aoc-dev";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      { 
        devShells.default = pkgs.mkShell { buildInputs = [ 
          pkgs.stack 
          pkgs.pkg-config # needed by digest
          pkgs.zlib # needed by digest
          pkgs.haskellPackages.haskell-language-server 
          pkgs.haskellPackages.haskell-debug-adapter 
          ]; };
      }
    );
}
