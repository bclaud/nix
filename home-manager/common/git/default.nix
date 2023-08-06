{...}: {
  programs.git = {
    enable = true;
    userName = "Bruno Claudino";
    userEmail = "bruarrais@gmail.com";
    signing = {
      key = "70BB68EF03BF0AAF";
      signByDefault = true;
    };
    aliases = {
      l = "log --pretty=format:'%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]' --date=short";
      s = "status -s";
      c = "commit -m";
      cs = "commit -S -m";
      f = "fetch";
      ai = "commit -a";
    };
  };
}
