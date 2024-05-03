{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';



in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
      home.pointerCursor = 
          let 
            getFrom = url: hash: name: {
                gtk.enable = true;
                x11.enable = true;
                name = name;
                size = 48;
                package = 
                  pkgs.runCommand "moveUp" {} ''
                    mkdir -p $out/share/icons
                    ln -s ${pkgs.fetchzip {
                      url = url;
                      hash = hash;
                    }} $out/share/icons/${name}
                '';
              };
          in
            getFrom 
              "https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz"
              "sha256-FCjsCGiaDqWisNe7cMgkKv1LLye6OLBOfhtRnkmXsnY="
              "Dracula-cursors";
    	home.packages = with pkgs; [
            ripgrep ffmpeg tealdeer
            eza zoxide disfetch htop fzf
            pass gnupg bat
            unzip lowdown zk
            grim slurp slop
            imagemagick age libnotify
            git python3 lua zig 
            mpv firefox pqiv
            screen bandw maintenance
            wf-recorder anki-bin 
            vim
            
        ];
    };
}
