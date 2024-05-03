




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
    ];

    colorScheme = inputs.nix-colors.colorSchemes.dracula;
}
