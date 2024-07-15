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
      telegram-desktop
      slack
      qpwgraph
      pavucontrol

      # themes
      kanagawa-gtk-theme
      vimix-gtk-themes

      kanagawa-icon-theme
      papirus-icon-theme

      vimix-cursor-theme
      simp1e-cursors
      bibata-cursors
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;
    # gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
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
    mpris-proxy.enable = true; # enable earbud keys
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
