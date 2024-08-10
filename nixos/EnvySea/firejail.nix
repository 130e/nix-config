# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  user = "oar"; # giant oarfish
in {
  programs = {
    # https://nixos.wiki/wiki/firejail
    # Finally, hopefully this can be merged
    # https://github.com/nix-community/home-manager/issues/4763
    firejail = {
      enable = true;
      wrappedBinaries = {
        # NOTE: using default profile is already nicely handled by maintainer
        # No need: profile = "${pkgs.firejail}/etc/firejail/slack.profile";
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/firejail/default.nix#L66
        mpv = {
          executable = "${lib.getBin pkgs.mpv}/bin/mpv";
        };
        slack = {
          executable = "${lib.getBin pkgs.slack}/bin/slack --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [ "--env=GTK_THEME=Adwaita:dark" ];
        };
        telegram-desktop = {
          executable = "${lib.getBin pkgs.tdesktop}/bin/telegram-desktop --use-tray-icon --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [
            "--env=GTK_THEME=Adwaita:dark" # Enforce dark mode
            "--dbus-user.talk=org.kde.StatusNotifierWatcher" # Allow tray icon (should be upstreamed into signal-desktop.profile)
            "--dbus-user.talk=org.fcitx.Fcitx5" # TODO: look into this workaround
          ];
        };
        zoom = {
          executable = "${lib.getBin pkgs.zoom-us}/bin/zoom";
          extraArgs = [
            "--noblacklist=/home/${user}/.librewolf"
            "--whitelist=/home/${user}/.librewolf/profiles.ini"
            "--read-only=/home/${user}/.librewolf/profiles.ini"
          ];
        };
        brave = {
          executable = "${lib.getBin pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --enable-wayland-ime";
        };
        librewolf = {
          executable = "${lib.getBin pkgs.librewolf}/bin/librewolf";
          extraArgs = [
            "--dbus-user.talk=org.fcitx.Fcitx5" # TODO: look into this workaround
          ];
        };
        drawio = {
          executable = "${lib.getBin pkgs.drawio}/bin/drawio --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [
            "--whitelist=/home/${user}/box/work/drawio"
          ];
        };
      # End of wrappedBinaries
      };
    };
    # DE
    hyprland.enable = true;
    # Enable network monitoring
    iftop.enable = true;
    wireshark.enable = true;
    # End of program
  };

  security = {
    rtkit.enable = true; # Bluetooth realtime kit
    pam.services.hyprlock = {}; # Enable hyprlock to use PAM
    # app security
    apparmor = {
      enable = true;
      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };
    sudo.wheelNeedsPassword = false; # NoPasswd needed for wheel
    # End of security
  };
}
