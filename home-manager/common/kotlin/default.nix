{ pkgs, ...}: 
let

  gradle = pkgs.gradle.override { java = pkgs.jdk; };
  kotlin = pkgs.kotlin.override { jre = pkgs.jdk; };
in
{
  home.packages = with pkgs; [ kotlin gradle jdk kotlin-native ];
  home.sessionVariables = {
    GRADLE_HOME="${gradle}/lib/gradle";
  };
}

