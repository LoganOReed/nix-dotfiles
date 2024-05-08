




{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        # gui
        ./firefox
        ./foot
        ./kitty
        ./eww
        ./dunst
        ./hyprland
        ./sway
        ./i3
        ./gbar
        ./waybar
        ./tofi


        # cli
        ./nvim
        ./zsh
        ./git
        ./gpg
        ./direnv

        # system
        ./xdg
        ./packages

        # from external flakes
        inputs.nix-colors.homeManagerModules.default
        inputs.gBar.homeManagerModules.x86_64-linux.default
    ];

    colorScheme = inputs.nix-colors.colorSchemes.dracula;
}
