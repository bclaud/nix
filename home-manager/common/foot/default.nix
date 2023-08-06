{...}:

    {
        programs.foot = {
            enable = true;
            settings = {
            main = {
                font = "JetBrainsMono Nerdfont:size=13:line-height=16px";
                shell = "fish";
                term = "xterm-256color";
            };
            scrollback = {
                lines = 5000;
                multiplier = 5;
            };

            url = {
            launch = ''firefox ''${url}'';
            };

            key-bindings = {
            show-urls-launch = "Control+Shift+l";
            };

            colors = {
                background = "0x282828";
                foreground = "0xebdbb2";
                regular0 = "0x282828";
                regular1 = "0xcc241c";
                regular2 = "0x98971a";
                regular3 = "0xd79921";
                regular4 = "0x458588";
                regular5 = "0xb16286";
                regular6 = "0x689d6a";
                regular7 = "0xa89984";
                bright0 = "0x928374";
                bright1 = "0xfb4934";
                bright2 = "0xb8bb26";
                bright3 = "0xfabd2f";
                bright4 = "0x83a598";
                bright5 = "0xd3869b";
                bright6 = "0x8ec07c";
                bright7 = "0xebdbb2";
            };
        };
    };
}