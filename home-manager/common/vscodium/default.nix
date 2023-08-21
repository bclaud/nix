{pkgs, ...}: {
  home.packages = with pkgs; [vscodium python311 poetry];

}
