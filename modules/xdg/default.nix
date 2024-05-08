{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/documents/";
            download = "$HOME/downloads/";
            videos = "$HOME/documents/videos/";
            music = "$HOME/documents/music/";
            pictures = "$HOME/documents/pictures/";
            desktop = "$HOME/misc/xdg/";
            publicShare = "$HOME/misc/xdg/";
            templates = "$HOME/misc/xdg/";
        };
    };
}
