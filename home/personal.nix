{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    zotero
    zoom-us
    telegram-desktop
    wechat
    slack
    flameshot
  ];

  programs = {

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

}
