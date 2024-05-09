





{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];



    config.modules = {
        # gui
        firefox.enable = true;
        # foot.enable = true;
        kitty.enable = true;
        # eww.enable = true;
        dunst.enable = true;
        hyprland.enable = true;
        sway.enable = true;
        # i3.enable = true;
        gbar.enable = true;
        waybar.enable = true;
        # tofi.enable = true;

        # cli
        nvim.enable = true;
        zsh.enable = true;
        git.enable = true;
        gpg.enable = true;
        direnv.enable = true;

        # system
        xdg.enable = true;
        packages.enable = true;
        scripts.enable = true;
    };

}
