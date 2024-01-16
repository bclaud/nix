{lib, config, pkgs, ...}:
let
    cfg = config.myBrowser;
in
{
    options.myBrowser = {
        enable = lib.mkEnableOption "enable my browser";

        browser = lib.mkOption {
            default = pkgs.chromium;
            description = "sets the browser";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.browser ];
    };
}