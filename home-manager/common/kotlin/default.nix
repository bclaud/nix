{ pkgs, ... }:
let

  gradle = pkgs.gradle.override { java = pkgs.graalvm-ce; };
  kotlin = pkgs.kotlin.override { jre = pkgs.graalvm-ce; };
in
{
  home.packages = with pkgs; [
    kotlin
    gradle
    graalvm-ce
    kotlin-native
  ];
  home.sessionVariables = {
    GRADLE_HOME = "${gradle}/lib/gradle";
  };

  home.file."jdks/home-jdk".source = pkgs.graalvm-ce;
}
