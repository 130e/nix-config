# home-manager GUI desktop apps
{
  lib,
  pkgs,
  config,
  ...
}:
{
  # NOTE: Desktop specific config
  # Apply to system with GUI
  # ------------------------

  home = {
    packages = with pkgs; [
      # only office
      onlyoffice-bin
      # gtk themes
      kanagawa-gtk-theme
      vimix-gtk-themes
      # icon themes
      kanagawa-icon-theme
      papirus-icon-theme
      # cursor themes
      vimix-cursor-theme
      bibata-cursors
      # Personal APPs
      rofi-wayland
      drawio
      keepassxc
      kitty
      # foot
      xfce.thunar
      swappy
      # remmina
      steam-run
    ];
    # Force app to use wayland; doesn't work most of time
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  services = {
    # General
    network-manager-applet.enable = true; # nm gui
    blueman-applet.enable = true; # bluetooth gui
    mpris-proxy.enable = true; # earbud control
    playerctld.enable = true; # media key
  };

  # GTK and QT are configured here
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
    platformTheme.name = "qtct";
    # style = {
    #   # install kvantum and use it to set qt theme automatically
    #   name = "kvantum";
    #   # Kvantum theme package can be install as package separately
    # };
  };

  programs = {
    vscode = {
      # Easy and dirty
      enable = true;
      package = pkgs.vscodium.fhs;
    };

    chromium = {
      enable = true;
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
        # "privacy.resistFingerprinting.letterboxing" = true;
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    # pyqt bug
    # qutebrowser = {
    #   enable = true;
    #   searchEngines = {
    #     DEFAULT = "https://search.brave.com/search?q={}";
    #     g = "https://www.google.com/search?hl=en&q={}";
    #     spg = "https://www.startpage.com/sp/search?query={}";
    #     nxp = "https://search.nixos.org/packages?channel=unstable&type=packages&query={}";
    #     hm = "https://home-manager-options.extranix.com/?query={}";
    #   };
    #   extraConfig = ''
    #     c.content.pdfjs = True
    #     c.auto_save.session = True
    #     c.session.lazy_restore = True
    #   '';
    # };

    zathura = {
      enable = true;
      options = {
        recolor = false; # do not recolor by default
        recolor-darkcolor = "#dcd7ba";
        recolor-lightcolor = "#1f1f28";
        recolor-keephue = true;
        # font = "OpenDyslexic Nerd Font";
        selection-clipboard = "clipboard";
      };
    };
  };

  xdg = {
    # NOTE: some app I prefer dotfile
    configFile = {
      "kitty" = {
        source = ../dotfiles/kitty;
        recursive = true;
      };

      "rofi" = {
        source = ../dotfiles/rofi;
        recursive = true;
      };

      # Set Kvantum theme declaratively and as readonly
      # "Kvantum/kvantum.kvconfig".text = ''
      #   [General]
      #   theme=Catppuccin-Frappe-Blue
      # '';
      # If you need copy kvantum theme from install folder
      # "Kvantum/Catppuccin-Frappe-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frappe-Blue";
    };

    desktopEntries = {
      "kakoune" = {
        name = "Kakoune";
        genericName = "Text Editor";
        # NOTE: enable xdg-open being called from anywhere to open a terminal correctly
        exec = "kitty kak %F";
        terminal = true;
        type = "Application";
        icon = "kakoune";
        categories = [
          "Utility"
          "TextEditor"
        ];
        startupNotify = false;
        mimeType = [ "text/*" ];
        settings = {
          TryExec = "kak";
          Keywords = "Text;editor";
        };
      };
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
        "application/x-sh" = [ "kakoune.desktop" ];
        "application/x-shellscript" = [ "kakoune.desktop" ];
        "text/html" = [ "librewolf.desktop" ];
        "text/plain" = [
          "kakoune.desktop"
          "Helix.desktop"
        ];
        "text/markdown" = [
          "kakoune.desktop"
          "Helix.desktop"
        ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
        "x-scheme-handler/kitty" = [ "kitty.desktop" ];
        "x-scheme-handler/ssh" = [ "kitty.desktop" ];
      };
    };

    portal.xdgOpenUsePortal = true;
  };

}
