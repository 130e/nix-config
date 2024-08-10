{
  pkgs,
  config,
  ...
}: {

  # [Optional] If you want to create/modify a desktop entry
  # Copy-paste and modify desktop entries here beacause:
  # 1) If app are installed by firejail, no desktop entry installed
  # 2) If not firejail, electro app need wayland argument 
  xdg = {
    # configFile = {
    #   # Custom firejail profiles
    #   firejail = {
    #     source = ./firejail;
    #     recursive = true;
    #   };
    #   # Set Kvantum theme declaratively and as readonly
    #   "Kvantum/kvantum.kvconfig".text = ''
    #     [General]
    #     theme=Catppuccin-Frappe-Blue
    #   '';
    #   # If you need copy kvantum theme from install folder
    #   "Kvantum/Catppuccin-Frappe-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frappe-Blue";
    # };
    desktopEntries = {
      "org.telegram.desktop" = {
        name = "Telegram Desktop";
        comment = "Official desktop version of Telegram messaging app";
        exec = "telegram-desktop -- %u";
        # exec = "telegram-desktop --enable-features=UseOzonePlatform --enable-wayland-ime -- %u";
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

      "slack" = {
        name = "Slack";
        comment = "Slack Desktop";
        genericName = "Slack Client for Linux";
        exec = "slack -s %U";
        # exec = "slack --enable-features=UseOzonePlatform --enable-wayland-ime -s %U";
        icon="slack";
        terminal=false;
        type="Application";
        startupNotify=true;
        categories=["GNOME" "GTK" "Network" "InstantMessaging"];
        mimeType=["x-scheme-handler/slack"];
        settings = {
          StartupWMClass="Slack";
        };
      };

      "brave-browser" = {
        name = "Brave Web Browser";
        comment = "Access the Internet";
        genericName = "Web Browser";
        exec = "brave %U";
        icon="brave-browser";
        terminal=false;
        type="Application";
        startupNotify=true;
        categories=["Network" "WebBrowser"];
        mimeType=[
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ipfs"
          "x-scheme-handler/ipns"
        ];
        actions = {
          "new-window" = {
            exec="brave";
            name="New Window";
          };
          "new-private-window" = {
            exec="brave --incognito";
            name="New Incognito Window";
          };
        };
      };

      "librewolf" = {
        name = "Librewolf";
        genericName = "Web Browser";
        exec = "librewolf --name librewolf %U";
        icon="librewolf";
        terminal=false;
        type="Application";
        startupNotify=true;
        categories=["Network" "WebBrowser"];
        settings = {
          StartupWMClass="librewolf";
        };
        mimeType=[
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        actions = {
          "new-window" = {
            exec="librewolf --new-window %U";
            name="New Window";
          };
          "new-private-window" = {
            exec="librewolf --private-window %U";
            name="New Private Window";
          };
          "profile-manager-window" = {
            exec="librewolf --ProfileManager";
            name="Profile Manager";
          };
        };
      };

      "drawio" = {
        name = "drawio";
        comment = "draw.io desktop";
        exec = "drawio %U";
        icon="drawio";
        type="Application";
        categories=["Graphics"];
        mimeType=[
          "application/vnd.jgraph.mxfile"
          "application/vnd.visio"
        ];
        settings = {
          StartupWMClass="draw.io";
        };
      };
    # End of xdg desktopEntries 
    };
  # End of xdg
  };
  # End of config
}
