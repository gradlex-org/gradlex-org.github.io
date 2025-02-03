{
  description = "Development shell for working on the sources of gradlex.org";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks, ...}: flake-utils.lib.eachDefaultSystem (system: let
     pkgs = import nixpkgs {inherit system;};
  in {
    checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        prettier.enable = true;
      };
    };
    devShells.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = with pkgs; [
        nodejs_23
      ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
    };
  });
}
