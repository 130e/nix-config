{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hypr.nix
  ];

  programs = {
    zathura = {
      enable = true;
      options = {
        recolor = false; # do not recolor by default
        recolor-darkcolor = "#dcd7ba";
        recolor-lightcolor = "#1f1f28";
        recolor-keephue = true;
      };
    };

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

        # TODO: Try this suggested method when have time. https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore
        # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=[VERSION]&x=id%3D[EXTENSION_ID]%26installsource%3Dondemand%26uc
        # Fill in VERSION and EXTENSION_ID

        # Static declare extension. Need manually updating
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
      enable = true;
      settings = {
        # "webgl.disabled" = false;
        # "privacy.resistFingerprinting" = false;
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

  # End programs
  };

  home = {
    packages = with pkgs; [
      # desktop
      xdg-utils
      # Apps
      xfce.thunar
      keepassxc
      steam-run
      spotube # TODO: Jail this thing
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

  services = {
    # network-manager-applet.enable = true;
    blueman-applet.enable = true; # bluetooth gui
    mpris-proxy.enable = true; # enable earbud control
    playerctld.enable = true; # enable media key
    # spotifyd requires premium
    # spotifyd = {
    #   enable = true;
    #   settings = {
    #     global = {
    #       username = "Alex";
    #       password = "foo";
    #       device_name = "nix";
    #     };
    #   };
    # # End spotifyd
    # };
  # End services
  };

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
    # End of xdg desktopEntries 
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = ["librewolf.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop"];
        "text/html" = ["librewolf.desktop"];
        # "image/png" = ["swappy"]; # TODO: might need to add swappy as a desktop
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      };
    };

    portal.xdgOpenUsePortal = true;
  # End of xdg
  };
  # End of config
}
