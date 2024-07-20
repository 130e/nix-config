{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hypr.nix
  ];

  programs = {
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      package = pkgs.ungoogled-chromium;
    };

    librewolf = {
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
      slack
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

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  services = {
    blueman-applet.enable = true;
    mpris-proxy.enable = true; # enable earbud control
    playerctld.enable = true;
  };

  # [Optional] If you want to create/modify a desktop entry
  # xdg.desktopEntries = {
  #   org.telegram.desktop.desktop = {
  #     name = "Telegram Desktop";
  #     comment = "Official desktop version of Telegram messaging app";
  #     exec = "telegram-desktop --enable-features=UseOzonePlatform --enable-wayland-ime";
  #     icon="telegram";
  #     terminal=false;
  #     type="Application";
  #     categories=["Chat" "Network" "InstantMessaging" "Qt"];
  #     mimeType=["x-scheme-handler/tg"];
  #     settings = {
  #       TryExec = "telegram-desktop";
  #       StartupWMClass="TelegramDesktop";
  #       Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
  #       DBusActivatable="true";
  #       SingleMainWindow="true";
  #       X-GNOME-UsesNotifications="true";
  #       X-GNOME-SingleWindow="true";
  #     };
  #     actions = {
  #       "quit" = {
  #         exec="telegram-desktop -quit";
  #         name="Quit Telegram";
  #         icon="application-exit";
  #       };
  #     };
  #   };
  # };
}
