{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Video tools
    ffmpeg

    # Network tools
    nmap
    netcat
    iperf3
    tcpdump

    # Utils
    jq
    fzf
    ripgrep
    file
    which
    tree

    # Archive
    p7zip
    unzip
    xz
    zip

    # Format & Lint
    black
    nixfmt
    pylint
    prettier
    shfmt

    # Misc
    fastfetch
    btop
    cowsay
    glow
  ];

  programs.git = {
    enable = true;
    userName = "130e";
    userEmail = "fernival328@gmail.com";
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  programs.kakoune = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.readFile ../dotfiles/kak/kakrc;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true; # TOFIX: Need OS config. Check source
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      kf = "kak $(fzf)"; # Hardcoded
    };
    history.size = 10000;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
