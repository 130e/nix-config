{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hypr.nix
  ];

  programs = {
    # Not sure emptyDirectory would work here
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      package = pkgs.ungoogled-chromium;
      extensions = [
        # How to fetch crx url
        # curl -Lo /dev/null -w '%{url_effective}\n' 'https://clients2.google.com/service/update2/crx?response=redirect&prodversion=49.0&acceptformat=crx3&x=id%3D''EXT_ID_GOES_HERE''%26installsource%3Dondemand%26uc'
        # This part is static. Need to manually update extensions
        # uBlock Origin
        {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          version = "1.58.0";
          crxPath = builtins.fetchurl {
            url = "https://clients2.googleusercontent.com/crx/blobs/AVsOOGivjvqM7c6ZTIGSqAHOrOA78anTtk30nNqUW1_blKEujiTw23yddTYyaayltPFYllgCtittddTj6mpJpoez7YmHw3QgomBqUptiiZewlLtVB-aYIfEZ012mvZWRWA_eAMZSmuXsad8B-ntbaEaPnBZ4y8Ume-gfYw/CJPALHDLNBPAFIAMEJDNHCPHJBKEIAGM_1_58_0_0.crx";
            sha256 = "sha256:746a98572d2ae68e1040abc0bdb1926c168191965c53ef571617633428497306";
          };
        }
        # vimium
        {
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          version = "2.1.2";
          crxPath = builtins.fetchurl {
            url = "https://clients2.googleusercontent.com/crx/blobs/AVsOOGjxj7oB6lhOoScED_U6UzhzkB6nzTgU813UcfuqvdPXcYR38oQXe1Wdk6mduJwfGzMaKTsIW-TUfZkoDoRZTxAOGjoai8w5Tmd5-8pwnmZWNXmUSBdqeHYBRXzHtsQAxlKa5dQpCeiloPaF4LV7-T0quT7N75za/DBEPGGEOGBAIBHGNHHNDOJPEPIIHCMEB_2_1_2_0.crx";
            sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
          };
        }
      ];
    };

    librewolf = {
      # package = pkgs.emptyDirectory; # firejail install it for us
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    # qutebrowser = {
    #   enable = true;
    #   searchEngines = {
    #     DEFAULT = "https://www.startpage.com/sp/search?query={}";
    #     g = "https://www.google.com/search?hl=en&q={}";
    #     nw = "https://wiki.nixos.org/index.php?search={}";
    #     hm = "https://home-manager-options.extranix.com/?query={}";
    #   };
    #   extraConfig = ''
    #     c.content.pdfjs = True
    #     c.auto_save.session = True
    #     c.session.lazy_restore = True
    #     c.url.default_page = "https://www.startpage.com/do/mypage.pl?prfe=9d62635f7829a75deaa1031e094f76a9011877e47e0a9cf971eb2310d44a64be5440a0ad06078a8e171817f36442ad6a7e5e1e86106af1a487114c626138a30a616138e3bc3dc671a053f958"
    #     c.url.start_pages = "https://www.startpage.com/do/mypage.pl?prfe=9d62635f7829a75deaa1031e094f76a9011877e47e0a9cf971eb2310d44a64be5440a0ad06078a8e171817f36442ad6a7e5e1e86106af1a487114c626138a30a616138e3bc3dc671a053f958"
    #   '';
    # };

    zathura = {
      enable = true;
      options = {
        recolor = false; # do not recolor by default
        recolor-darkcolor = "#dcd7ba";
        recolor-lightcolor = "#1f1f28";
        recolor-keephue = true;
      };
    };

  };

  home = {
    packages = with pkgs; [
      # Apps
      telegram-desktop
      xfce.thunar
      keepassxc
      steam-run
      # Audio
      qpwgraph
      pavucontrol
      playerctl
      pamixer
      # Display
      swww
      brightnessctl
      # gtk themes
      kanagawa-gtk-theme
      vimix-gtk-themes
      # icon themes
      kanagawa-icon-theme
      papirus-icon-theme
      # cursor themes
      vimix-cursor-theme
      simp1e-cursors
      bibata-cursors
    ];
    # Force app to use wayland; doesn't work most of time
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;
    # gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    # theme: /etc/profiles/per-user/$USER/share
    theme = {
      # Dark theme
      name = "Kanagawa-BL";
      # Light theme
      # name = "vimix-light-doder";
    };
    iconTheme = {
      name = "Papirus";
      # name = "Vimix-Doder";
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      # name = "Vimix-Cursors";
      size = 24;
    };
  };

  # Use variables?
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    # style = {
    #   # install kvantum and use it to set qt theme automatically
    #   name = "kvantum";
    #   # Kvantum theme package can be install as package separately
    # };
  };

  # Set Kvantum theme declaratively and as readonly
  # xdg.configFile = {
  #   "Kvantum/kvantum.kvconfig".text = ''
  #     [General]
  #     theme=Catppuccin-Frappe-Blue
  #   '';
  #   # If you need copy kvantum theme from install folder
  #   "Kvantum/Catppuccin-Frappe-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frappe-Blue";
  # };

  services = {
    blueman-applet.enable = true;
    mpris-proxy.enable = true; # enable earbud control
    playerctld.enable = true;
  };

  # [Optional] If you want to create/modify a desktop entry
  xdg.desktopEntries = {
    "org.telegram.desktop" = {
      name = "Telegram Desktop";
      comment = "Official desktop version of Telegram messaging app";
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

    "slack" = {
      name = "Slack";
      comment = "Slack Desktop";
      genericName = "Slack Client for Linux";
      exec = "slack --enable-features=UseOzonePlatform --enable-wayland-ime -s %U";
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

    # "brave-browser" = {
    #   name = "Brave Web Browser";
    #   comment = "Access the Internet";
    #   genericName = "Web Browser";
    #   exec = "brave --enable-features=UseOzonePlatform --enable-wayland-ime %U";
    #   icon="brave-browser";
    #   terminal=false;
    #   type="Application";
    #   startupNotify=true;
    #   categories=["Network" "WebBrowser"];
    #   mimeType=[
    #     "application/pdf"
    #     "application/rdf+xml"
    #     "application/rss+xml"
    #     "application/xhtml+xml"
    #     "application/xhtml_xml"
    #     "application/xml"
    #     "image/gif"
    #     "image/jpeg"
    #     "image/png"
    #     "image/webp"
    #     "text/html"
    #     "text/xml"
    #     "x-scheme-handler/http"
    #     "x-scheme-handler/https"
    #     "x-scheme-handler/ipfs"
    #     "x-scheme-handler/ipns"
    #   ];
    #   actions = {
    #     "new-window" = {
    #       exec="brave --enable-features=UseOzonePlatform --enable-wayland-ime";
    #       name="New Window";
    #     };
    #     "new-private-window" = {
    #       exec="brave --enable-features=UseOzonePlatform --enable-wayland-ime --incognito";
    #       name="New Incognito Window";
    #     };
    #   };
    # };
  # End of xdg desktopEntries 
  };
  # End of config
}
