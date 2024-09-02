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
    # extraPackages = with pkgs; [ ];
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
        "image/png" = ["swappy.desktop"]; # TODO: might need to add swappy as a desktop
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
