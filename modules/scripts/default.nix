{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.scripts;
    bashmount = pkgs.writeShellScriptBin "bashmount" ''${builtins.readFile ./bashmount.sh}'';
in {
    options.modules.scripts = { enable = mkEnableOption "scripts"; };
    config = mkIf cfg.enable {
        home.packages = [
            bashmount
        ];
    };
}
