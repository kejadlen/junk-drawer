{ pkgs ? import <nixpkgs> {} }:
let
  my-python = pkgs.python3.buildEnv.override {
    extraLibs = [ pkgs.python3Packages.z3 ];
  };
in

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.go
    my-python
    pkgs.ruby
    pkgs.z3
  ];
}
