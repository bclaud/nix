final: prev: {
  postman = prev.postman.overrideAttrs (previousAttrs: rec {
    version = "10.22.0";
    src = prev.fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/linux64";
      name = "postman-${version}.tar.gz";
      sha256 = "sha256-Ii6ScBPuYxyzH2cGSTuDlUFG3nS1rTLTGqXqVbz5Epo=";
    };
  });
}
