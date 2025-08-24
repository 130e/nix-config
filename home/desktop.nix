{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    zotero
    wireshark
  ];

  programs = {

    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        # "privacy.resistFingerprinting.letterboxing" = true;
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    kitty = {
      enable = true;
      # TODO: font
      # shellIntegration.enableZshIntegration = true;
    };

    keepassxc = {
      enable = true;
      settings = {
        GUI = {
          MinimizeToTray = true;
          MinimizeOnClose = true;
          ColorPasswords = true;
          CompactMode = true;
        };
        Security = {
          ClearClipboardTimeout = 30;
          LockDatabaseScreenLock = false;
        };
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
          # UseCustomBrowser = ""; # TODO
        };
      };
    };

  };

  services = {
    syncthing.enable = true;
  };
}
