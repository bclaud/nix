{ inputs, ... }:
[
  (import ./postman.nix)

  (final: prev: {
    idea-community-fhs = (prev.buildFHSUserEnv {
      name = "idea-community";
      targetPkgs = pkgs: [ ];
      multiPkgs = pkgs: [ pkgs.jetbrains.idea-community ];
      runScript = "idea-community $*";
    });
  })

  (final: prev: {
    pycharm-community-fhs = (prev.buildFHSUserEnv {
      name = "pycharm-community";
      targetPkgs = pkgs: [ ];
      multiPkgs = pkgs: [ pkgs.jetbrains.pycharm-community];
      runScript = "pycharm-community $*";
    });
  })


]
