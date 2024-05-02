{ config, pkgs, inputs, ... }:

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

    programs.zsh.enable = true;

    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
        acpi tlp git light
    ];

    # Install fonts
    fonts = {
        fonts = with pkgs; [
            iosevka-comfy.comfy
            noto-fonts
            font-awesome
            powerline-symbols
            openmoji-color
            (nerdfonts.override { fonts = [ "Iosevka" ]; })
        ];

        fontconfig = {
            hinting.autohint = true;
            defaultFonts = {
              emoji = [ "OpenMoji Color" ];
            };
        };
    };


    # Wayland stuff: enable XDG integration, allow sway to use brillo
    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
            gtkUsePortal = true;
        };
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
        cleanTmpDir = true;
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
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
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
