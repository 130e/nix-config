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
      foot
      xfce.thunar
      swappy
      remmina
      steam-run
      lutris
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
    # Easy and dirty
    vscode = {
      enable = true;
      package = pkgs.vscodium.fhs;
    };
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      package = pkgs.ungoogled-chromium;
      # TODO: Can/should I skip sha256? Or, how do I pin crx version
      # NOTE: manually download plugin
      # Ref: https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore
      # Ref: https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214
      # url = https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=[VERSION]&x=id%3D[EXTENSION_ID]%26installsource%3Dondemand%26uc
      # Fill in chromium VERSION and EXTENSION_ID
      extensions =
        let
          createChromiumExtensionFor =
            browserVersion:
            {
              id,
              sha256,
              version,
            }:
            {
              inherit id;
              crxPath = builtins.fetchurl {
                url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                name = "${id}.crx";
                inherit sha256;
              };
              inherit version;
            };
          createChromiumExtension = createChromiumExtensionFor (
            lib.versions.major pkgs.ungoogled-chromium.version
          );
        in
        [
          (createChromiumExtension {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            sha256 = "sha256:37992b0b9aa7a6b94f4fdf1385e503f237a55cea593fd1c254e9c02dcc01671a";
            version = "1.59.0";
          })
          (createChromiumExtension {
            # Vimium
            id = "dbepggeogbaibhgnhhndojpepiihcmeb";
            sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
            version = "2.1.2";
          })
          (createChromiumExtension {
            # Dark reader
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sha256 = "sha256:06099ee57eb4b07d6f2331807a3a7ed8b66e90ac2f9f984476489bba623c528f";
            version = "4.9.90";
          })
          (createChromiumExtension {
            # Privacy badger
            id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
            sha256 = "sha256:1f0483a03a92466bbdc47c05eac81931ea6d54f32851f7c8e55cb62ff651584b";
            version = "2024.7.17";
          })
        ];
      # If not using ungoogled-chromium:
      # extensions = [
      #   # updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3D[EXTENSION_ID]%26uc";
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
        # "privacy.clearOnShutdown.history" = false;
        # "privacy.clearOnShutdown.downloads" = false;
        # "privacy.clearOnShutdown.cookies" = false;
        # "network.cookie.lifetimePolicy" = 0;
      };
    };

    qutebrowser = {
      enable = true;
      searchEngines = {
        DEFAULT = "https://search.brave.com/search?q={}";
        g = "https://www.google.com/search?hl=en&q={}";
        spg = "https://www.startpage.com/sp/search?query={}";
        nxp = "https://search.nixos.org/packages?channel=unstable&type=packages&query={}";
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
        font = "OpenDyslexic Nerd Font";
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
        "text/*" = [
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
