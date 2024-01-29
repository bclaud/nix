{ inputs, ... }:
[
  (final: prev: {
    postman = prev.postman.overrideAttrs (previousAttrs: {
      version = "10.18.10";
      src = prev.fetchurl {
        url = "https://dl.pstmn.io/download/version/10.18.10/linux64";
        name = "postman-10.18.10.tar.gz";
        sha256 = "sha256-CAY9b2O+1vROUEfGRReZex9Sh5lb3sIC4TExVHRL6Vo=";
      };
    });
  })
  inputs.unison-nix.overlay
]
