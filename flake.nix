{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-miden.url = "github:cameronfyfe/nixpkgs/add-miden-vm";
    nixpkgs-present.url = "github:cameronfyfe/nixpkgs/add-present-cli";
  };

  outputs = inputs @ { self, ... }:
    (inputs.flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = inputs.nixpkgs.legacyPackages.${system};

        miden-vm = inputs.nixpkgs-miden.legacyPackages.${system}.miden-vm;

        present-cli = inputs.nixpkgs-present.legacyPackages.${system}.present-cli;

      in
      rec {

        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              miden-vm
              present-cli
            ] ++ (with pkgs; [
              gnumake
              nixpkgs-fmt
            ]);
          };
        };

      }));
}
