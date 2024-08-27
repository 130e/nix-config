# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "oar";
    homeDirectory = "/home/oar";
  };

  # Custom home settings
  # ---------------------

  # Enable home-manager and git
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
    ];
    withNodeJs = true;
    withPython3 = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true; # this option is readonly and always true
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      l = "ls -ahl";
      ll = "ls -l";
    };
  };

  programs.btop.enable = true;

  # Home packages
  # --------------

  home.packages = with pkgs; [
    neofetch

    # General code
    python3
    gcc
    gnumake

    # archive
    zip
    unzip
    xz
    p7zip

    # utils
    ripgrep
    tree
    bc
    unrar-free
    ffmpeg
    file

    # network
    tcpdump
    iperf3
    nethogs
  ];

  # services
  # ---------

  services.syncthing.enable = true;

  # Desktop specific config
  # TODO: should not be used in headless system
  # ------------------------
  
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
      extensions = [
        # Method 1) get the crx url
        # curl -Lo /dev/null -w '%{url_effective}\n' 'https://clients2.google.com/service/update2/crx?response=redirect&prodversion=49.0&acceptformat=crx3&x=id%3D''EXT_ID_GOES_HERE''%26installsource%3Dondemand%26uc'
        # TODO: method 2 failed as fetched file contained illegal characters
        # Method 2) Static config. Ref: https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore
        # url = https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=[VERSION]&x=id%3D[EXTENSION_ID]%26installsource%3Dondemand%26uc
        # Fill in chromium VERSION and EXTENSION_ID
        
        # Need manually updating checksum and version

        # Static declare extension. Need manually updating
        # uBlock Origin
        {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          version = "1.59.0";
          crxPath = builtins.fetchurl {
            url = "https://clients2.googleusercontent.com/crx/blobs/AVsOOGg1apbLN50mmrm74N9Oyxy0U3TZRr5rWsT8t_VZfeExDoJSUTI2YXyRgqtTML8vRuFDsqx1O2LJDly9pJXEuoUnbeJBwNNwlWVKv_ai1dKqxVY6dmqgi7uB-DDlF93oAMZSmuUG7KBUSYKwdbgX2SH3AX6K1J2cLw/CJPALHDLNBPAFIAMEJDNHCPHJBKEIAGM_1_59_0_0.crx";
            sha256 = "sha256:37992b0b9aa7a6b94f4fdf1385e503f237a55cea593fd1c254e9c02dcc01671a";
          };
        }
        # vimium
        # {
        #   id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        #   version = "2.1.2";
        #   crxPath = builtins.fetchurl {
        #     url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=128.0&x=id%3Ddbepggeogbaibhgnhhndojpepiihcmeb%26installsource%3Dondemand%26uc";
        #     sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
        #   };
        # }
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

    #desktopEntries = {
    #  "org.telegram.desktop" = {
    #    name = "Telegram Desktop";
    #    comment = "Official desktop version of Telegram messaging app";
    #    # exec = "telegram-desktop -- %u";
    #    exec = "telegram-desktop --enable-features=UseOzonePlatform --enable-wayland-ime -- %u";
    #    icon="telegram";
    #    terminal=false;
    #    type="Application";
    #    categories=["Chat" "Network" "InstantMessaging" "Qt"];
    #    mimeType=["x-scheme-handler/tg"];
    #    settings = {
    #      TryExec = "telegram-desktop";
    #      StartupWMClass="TelegramDesktop";
    #      Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
    #      DBusActivatable="true";
    #      SingleMainWindow="true";
    #      X-GNOME-UsesNotifications="true";
    #      X-GNOME-SingleWindow="true";
    #    };
    #    actions = {
    #      "quit" = {
    #        exec="telegram-desktop -quit";
    #        name="Quit Telegram";
    #        icon="application-exit";
    #      };
    #    };
    #  };
    #};

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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
