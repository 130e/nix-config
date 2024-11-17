# Code snippets & Notes

## Power saving

tlp utilities for turning dev on and off `wifi, nfc, bluetooth`.

## Nixos

```nix

```

## home-manager

```nix
  # [Optional] If you want to create/modify a desktop entry
  # Copy-paste and modify desktop entries here beacause:
  # 1) If app are installed by firejail, no desktop entry installed
  # 2) If not firejail, electro app need wayland argument
  xdg = {
    configFile = {
      # Custom firejail profiles
      firejail = {
        source = ./firejail;
        recursive = true;
      };
      # Set Kvantum theme declaratively and as readonly
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Frappe-Blue
      '';
      # If you need copy kvantum theme from install folder
      "Kvantum/Catppuccin-Frappe-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frappe-Blue";
    };

    desktopEntries = {
      "org.telegram.desktop" = {
        name = "Telegram Desktop";
        comment = "Official desktop version of Telegram messaging app";
        # exec = "telegram-desktop -- %u";
        exec = "telegram-desktop --enable-features=UseOzonePlatform --enable-wayland-ime -- %u";
        icon="telegram";
        terminal=false;
        type="Application";
        categories=["Chat" "Network" "InstantMessaging" "Qt"];
        mimeType=["x-scheme-handler/tg"];
        settings = {
          TryExec = "telegram-desktop";
          StartupWMClass="TelegramDesktop";
          Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
          DBusActivatable="true";
          SingleMainWindow="true";
          X-GNOME-UsesNotifications="true";
          X-GNOME-SingleWindow="true";
        };
        actions = {
          "quit" = {
            exec="telegram-desktop -quit";
            name="Quit Telegram";
            icon="application-exit";
          };
        };
      };
    };
```
