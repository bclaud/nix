{ inputs, ... }:
[
  inputs.unison-nix.overlay

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

  (final: prev: {
    elixir-ls = (prev.elixir-ls.override {elixir = prev.beam.packages.erlang_26.elixir_1_16; }).overrideAttrs (old: {
      buildPhase = ''
        runHook preBuild

        mix do compile --no-deps-check, elixir_ls.release2
        runHook postBuild
      '';
    });
  })


]
