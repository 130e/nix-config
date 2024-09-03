{
  lib,
  pkgs,
  config,
  ...
}: {
  # NOTE: Desktop specific config
  # Apply to system with GUI
  # ------------------------
  
  home = {
    packages = with pkgs; [
      # gtk themes
      kanagawa-gtk-theme
      vimix-gtk-themes
      # icon themes
      kanagawa-icon-theme
      papirus-icon-theme
      # cursor themes
      vimix-cursor-theme
      bibata-cursors
    ];
    # Force app to use wayland; doesn't work most of time
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  services = {
    network-manager-applet.enable = true;
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
    # };
  };

  # GTK and QT are configured here
  # Themes are installed system wide
  # But no system wide option for configuring theme
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
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      package = pkgs.ungoogled-chromium;
      # Ref: https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore
      # Ref: https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214
      # url = https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=[VERSION]&x=id%3D[EXTENSION_ID]%26installsource%3Dondemand%26uc
      # Fill in chromium VERSION and EXTENSION_ID
      extensions = 
      let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:37992b0b9aa7a6b94f4fdf1385e503f237a55cea593fd1c254e9c02dcc01671a";
          version = "1.59.0";
        })
        (createChromiumExtension {
          # vimium
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
          version = "2.1.2";
        })
        (createChromiumExtension {
          # dark reader
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          sha256 = "sha256:d3a604e7dfe4d7482acd447804c1e32ce1fe007915f0a77bda85746e3b38ec23";
          version = "4.9.89";
        })
      ];
      # If not using ungoogled-chromium:
      # extensions = [
      #   
      #   # updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3D[EXTENSION_ID]%26uc";
      #
      #   # Static declare extension. Need manually updating
      #   # uBlock Origin
      #   {
      #     id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      #     updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26uc";
      #   }
      #   # vimium
      #   {
      #     id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      #     updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3Ddbepggeogbaibhgnhhndojpepiihcmeb%26uc";
      #   }
      # ];
    };

    librewolf = {
      enable = true;
      settings = {
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    qutebrowser = {
      enable = true;
      searchEngines = {
        DEFAULT = "https://www.startpage.com/sp/search?query={}";
        g = "https://www.google.com/search?hl=en&q={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        hm = "https://home-manager-options.extranix.com/?query={}";
      };
      extraConfig = ''
        c.content.pdfjs = True
        c.auto_save.session = True
        c.session.lazy_restore = True
      '';
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
      "swappy" = {
        name = "Swappy";
        exec = "swappy %U";
        icon = "Swappy";
        mimeType = ["image/png"];
      };
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = ["librewolf.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop"];
        "text/html" = ["librewolf.desktop"];
        "image/png" = ["swappy.desktop"];
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      };
    };

    portal.xdgOpenUsePortal = true;
  };

}
