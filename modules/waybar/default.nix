{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.waybar;

in {
    options.modules.waybar = { enable = mkEnableOption "waybar"; };
    config = mkIf cfg.enable {
      programs.waybar = with config.colorscheme.palette; {
        enable = true;
        settings = 
          {
            mainBar = {
              layer = "top";
              position = "top";
              height = 30;
              # output = [
              #   "eDP-1"
              # ];

              modules-left = ["sway/workspaces" "tray" "sway/mode"];
              modules-center = ["sway/window"];
              modules-right = [ "idle_inhibitor" "network" "pulseaudio" "battery" "clock"];

               "sway/workspaces" = {
                   disable-scroll = true;
                   all-outputs = true;
                   format = "{icon} {name}";
                   format-icons = {
                       "1" = " ";
                       "2" = " ";
                       "3" = " ";
                       "4" = " ";
                       "5" = " ";
                       urgent = " ";
                       # focused = "";
                       default = " ";
                   };
              };

              "sway/mode" = {
                      format = "<span style=\"italic\">{}</span>";
                  };

              "disk#ssd" = {
                      interval = 30;
                      format = "{path} {free}";
                      path = "/";
                      tooltip = true;
                      warning = 75;
                      critical = 90;
                  };

              "network" = {
                      #interface = "enp1s0"; # (Optional) To force the use of this interface
                      format-wifi = "{essid} ({signalStrength}%) ";
                      # format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
                      format-ethernet = "TEMP NAME ";
                      format-linked = "TEMPNAME (No IP) ";
                      format-disconnected = "Disconnected ⚠";
                      format-alt = "{ifname}: {ipaddr}/{cidr}";
                  };

              "idle_inhibitor" = {
                  format = "{icon}";
                  format-icons = {
                      activated = "";
                      deactivated = "";
                  };
              };

              "clock" = {
                  timezone = "America/New_York";
                  format = "{:%F %R}";
                  tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              };

              "battery" = {
                  states = {
                      # good = 95;
                      warning = 30;
                      critical = 15;
                  };
                  format = "{capacity}% {icon}";
                  format-charging = "{capacity}% ";
                  format-plugged = "{capacity}% ";
                  format-alt = "{time} {icon}";
                  format-icons = ["" "" "" "" ""];
              };

              "pulseaudio" = {
                scroll-step = 5; # %, can be a float
                # format = "{volume}% {icon} {format_source}";
                format = "{volume}% {icon} ";
                format-bluetooth = "{volume}% {icon} {format_source}";
                format-bluetooth-muted = " {icon} {format_source}";
                format-muted = " {format_source}";
                format-source = "{volume}% ";
                format-source-muted = "";
                format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  # "default": ["", "", ""]
                };
                on-right-click = "pavucontrol";
              };

            };
          };

          style = ''
* { 
    all: unset;
    border: none;
    border-radius: 4;
    font-family: Iosevka Comfy Mono;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: @theme_base_color;
    background-color: rgba(43, 48, 59, 0.9);
    border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    color: @theme_text_color;
    transition-property: background-color;
    transition-duration: .5s;
    border-radius: 0;
}

window#waybar.hidden {
    opacity: 0.2;
}

tooltip {
  background: rgba(43, 48, 59, 0.5);
  border: 1px solid rgba(100, 114, 125, 0.5);
}

tooltip label {
  color: @theme_text_color;
}

/*
window#waybar.empty {
    background-color: transparent;
}
window#waybar.solo {
    background-color: #FFFFFF;
}
*/

#workspaces button {
    padding: 0 0.7em;
    background-color: transparent;
    color: #f8f8f2;
    box-shadow: inset 0 -3px transparent;
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.focused {
    background-color: #64727D;
    box-shadow: inset 0 -3px #f8f8f2;
}

#workspaces button.urgent {
    background-color: #eb4d4b;
}

#mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-weather,
#tray,
#mode,
#idle_inhibitor,
#custom-notification,
#sway-scratchpad,
#mpd {
    padding: 0 10px;
    margin: 6px 3px;
    color: #f8f8f2;
}

#window,
#workspaces {
    margin: 0 4px;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
    margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
    margin-right: 0;
}

#clock {
    background-color: #ff5555;
    color: #282a36;
}

#battery {
    background-color: #44475a;
    color: #f8f8f2;
}

#battery.charging, #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #f53c3c;
    color: #ffffff;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #000000;
}

#cpu {
    background-color: #f1fa8c;
    color: #282a36;
}

#memory {
    background-color: #f1fa8c;
    color: #282a36;
}

#backlight {
    background-color: #90b1b1;
}

#network {
    background-color: #50fa7b;
    color: #282a36;
}

#network.disconnected {
    background-color: #50fa7b;
    color: #282a36;
}

#pulseaudio {
    background-color: #bd93f9;
    color: #282a36;
}

#pulseaudio.muted {
    background-color: #44475a;
    color: #f8f8f2;
}

#custom-media.custom-spotify {
    background-color: #66cc99;
}

#custom-media.custom-vlc {
    background-color: #ffa000;
}

#temperature {
    background-color: #ff79c6;
    color: #282a36;
}

#temperature.critical {
    background-color: #ff5555;
    color: #282a36;
}

#tray {
    background-color: #bd93f9
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}

#idle_inhibitor {
    background-color: #44475a;
    color: #f8f8f2;
}

#idle_inhibitor.activated {
    background-color: #f8f8f2;
    color: #44475a;
}

#mpd {
    background-color: #66cc99;
    color: #2a5c45;
}

#mpd.disconnected {
    background-color: #f53c3c;
}

#mpd.stopped {
    background-color: #90b1b1;
}

#mpd.paused {
    background-color: #51a37a;
}

#language {
    background-color: #f8f8f2;
    color: #282a36;
    padding: 0 5px;
    margin: 6px 3px;
    min-width: 16px;
}

#keyboard-state {
    background-color: #97e1ad;
    color: #000000;
    padding: 0 0px;
    margin: 0 5px;
    min-width: 16px;
}

#keyboard-state > label {
    padding: 0 5px;
}

#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}

#custom-weather {
    background-color: #8be9fd;
    color: #282a36;
    margin-right: 5;
}

#disk {
    background-color: #ffb86c;
    color: #282a36;
}

#sway-scratchpad {
    background-color: #50fa7b;
    color: #282a36;
}
          '';
      };
    };
}

# scheme: "Darcula"
# author: "jetbrains"
# base00: "2b2b2b" # background
# base01: "323232" # line cursor
# base02: "323232" # statusline
# base03: "606366" # line numbers
# base04: "a4a3a3" # selected line number
# base05: "a9b7c6" # foreground
# base06: "ffc66d" # function bright yellow
# base07: "ffffff"
# base08: "4eade5" # cyan
# base09: "689757" # blue
# base0A: "bbb529" # yellow
# base0B: "6a8759" # string green
# base0C: "629755" # comment green
# base0D: "9876aa" # purple
# base0E: "cc7832" # orange
# base0F: "808080" # gray
