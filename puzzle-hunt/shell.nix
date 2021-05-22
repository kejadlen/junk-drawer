{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.go
    pkgs.python3
    pkgs.ruby_3_0
    pkgs.z3
  ];
}
