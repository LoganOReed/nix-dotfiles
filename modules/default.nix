




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
        ./scripts
        ./packages

        # from external flakes
        inputs.nix-colors.homeManagerModules.default
        inputs.gBar.homeManagerModules.x86_64-linux.default
    ];

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    colorScheme = inputs.nix-colors.colorSchemes.dracula;
}
