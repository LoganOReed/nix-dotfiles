{ config, pkgs, inputs, ... }:
let
    # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
        '';
  };
in

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];

    # For i3
    environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

    # services.xserver = {
    #   enable = true;
    #   desktopManager.xterm.enable = false;
    #   displayManager = {
    #     defaultSession = "none+i3";
    #   };
    #   windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [
    #     rofi          # application launcher, the same as dmenu
    #     dunst         # notification daemon
    #     i3blocks      # status bar
    #     i3lock        # default i3 screen locker
    #     xautolock     # lock screen after some time
    #     i3status      # provide information to i3bar
    #     i3-gaps       # i3 with gaps
    #     picom         # transparency and shadows
    #     feh           # set wallpaper
    #     acpi          # battery information
    #     arandr        # screen layout manager
    #     dex           # autostart applications
    #     xbindkeys     # bind keys to commands
    #     xorg.xbacklight  # control screen brightness
    #     xorg.xdpyinfo      # get screen information
    #     sysstat       # get system information
    #  ];
    # };
    # };

    programs.zsh.enable = true;


    # allows packages which aren't totally foss
    nixpkgs.config.allowUnfree = true;

    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
        acpi tlp git light dbus-sway-environment configure-gtk
    ];

    # Install fonts
    fonts = {
        packages = with pkgs; [
            iosevka-comfy.comfy
            noto-fonts
            font-awesome
            powerline-symbols
            openmoji-color
            (nerdfonts.override { fonts = [ "Iosevka" ]; })
        ];
    };


    # Wayland stuff: enable XDG integration, allow sway to use brillo
    security.pam.services.swaylock = {
      text = "auth include login";
    };

    xdg.portal = {
        enable = true;
        wlr.enable = true;
        # gtk portal needed to make gtk apps happy
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*"; 
      };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "occam" ];
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
        '';
    };

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 15;
        efi.canTouchEfiVariables = true;
        };
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };


    # Set up user and enable sudo
    users.users.occam = {
        initialPassword = "password";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
            #public key for laptop
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6sLwHf6YinWCrt0amlNhrWml3i+Vq7Ju1GcnAWd1zL occam@razor"
        ];
        extraGroups = [ "input" "wheel" "networkmanager" ];
        shell = pkgs.zsh;
    };

  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

   # A key remapping daemon for linux.
   # https://github.com/rvaiya/keyd
   services.keyd = {
     enable = true;
     keyboards = {
       default = {
         settings = {
           main = {
             # overloads the capslock key to function as both escape (when tapped) and control (when held)
             capslock = "overload(control, esc)";
           };
         };
       };
     };
   };

  # Enable CUPS to print documents.
  services.printing.enable = true;

    # Set up networking and secure it
    networking = {
        networkmanager.enable = true;
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_CACHE_HOME = "$HOME/.cache";
        GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
        EDITOR = "nvim";
    };

    # Security 
    security = {
        doas = {
            enable = true;
            extraRules = [{
                users = [ "occam" ];
                keepEnv = true;
                persist = true;
            }];
        };

        # Extra security
        protectKernelImage = true;
    };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

  };


    # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
    hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
        opengl = {
            enable = true;
            driSupport = true;
        };
    };

    # Do not touch
    system.stateVersion = "23.11";
}
