{ pkgs, ...}: {
  home.packages = with pkgs; [ kotlin gradle gcc ncurses zlib jdk ];
  home.sessionVariables = ''
    GRADLE_HOME=${pkgs.gradle}/lib/gradle
  '';
}

