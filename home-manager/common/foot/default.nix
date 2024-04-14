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

        };
    };
}
