# home-manager configuration file
# Set up basic headless environment for user
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
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
    withNodeJs = true;
    withPython3 = true;
  };
  # Vanilla nvchad
  xdg.configFile.nvim = {
    source = ../dotfiles/nvim;
    recursive = true;
  };

  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
      {
        name = "python";
        auto-format = true;
        formatter.command = "${pkgs.black}/bin/black";
      }
    ];
  };

  programs.kakoune = {
    defaultEditor = true;
    enable = true;
    extraConfig = builtins.readFile ../dotfiles/kak/kakrc;
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
    # enableFishIntegration = true; # default true
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      l = "ls -ahl";
      ll = "ls -ahl --color=never";
    };
  };

  programs.btop.enable = true;

  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = "kitty";
    };
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "FiraCode Nerd Font Mono"
        "Noto Sans Mono"
      ];
    };
  };

  # Home packages
  # --------------

  home.packages = with pkgs; [
    # General coding
    gcc
    gnumake
    python3
    # Linter
    python312Packages.flake8
    # Formatter
    black
    nil
    nixfmt-rfc-style
    nodePackages.prettier
    # LSP
    python312Packages.python-lsp-server
    clang-tools
    vscode-langservers-extracted # html/css/json...

    # Archive
    p7zip
    unzip
    xz
    zip

    # Utils
    bc
    fd
    ffmpeg
    file
    fzf
    git
    ripgrep
    tmux
    tree
    unrar-free

    # Network
    iperf3
    nmap
    qtwirediff
    tcpdump

    # Fonts I need fonts for editor :)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "SpaceMono"
        "FiraCode"
        "OpenDyslexic"
      ];
    })

    # rice
    fastfetch
  ];

  # services
  # ---------

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
