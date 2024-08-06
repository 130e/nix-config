# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  user = "oar"; # giant oarfish
in {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      # flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # storage optimization https://nixos.wiki/wiki/Storage_optimization
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Opinionated: disable channels
    # channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    # registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    # nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Custom system wide programs
  # ---------------------------
  
  # Use the systemd-boot EFI bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # List packages installed in system profile. To search, run:
  environment = {
    systemPackages = with pkgs; [
      vim # The Nano editor is also installed by default.
      wget
      curl
      git
    ];
    variables.EDITOR = "vim"; # Set the default editor to vim
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    # noto-fonts-monochrome-emoji
    noto-fonts-emoji-blob-bin
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Experimental = true; # Enable bat reporting
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    # VOLATILE: Set your hostname
    hostName = "EnvySea";
    networkmanager.enable = true;
  };

  programs = {
    # https://nixos.wiki/wiki/firejail
    # Finally, hopefully this can be merged
    # https://github.com/nix-community/home-manager/issues/4763
    firejail = {
      enable = true;
      wrappedBinaries = {
        # NOTE: using default profile is already nicely handled by maintainer
        # No need: profile = "${pkgs.firejail}/etc/firejail/slack.profile";
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/firejail/default.nix#L66
        mpv = {
          executable = "${lib.getBin pkgs.mpv}/bin/mpv";
        };
        slack = {
          executable = "${lib.getBin pkgs.slack}/bin/slack --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [ "--env=GTK_THEME=Adwaita:dark" ];
        };
        telegram-desktop = {
          executable = "${lib.getBin pkgs.tdesktop}/bin/telegram-desktop --use-tray-icon --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [
            "--env=GTK_THEME=Adwaita:dark" # Enforce dark mode
            "--dbus-user.talk=org.kde.StatusNotifierWatcher" # Allow tray icon (should be upstreamed into signal-desktop.profile)
            "--dbus-user.talk=org.fcitx.Fcitx5" # TODO: look into this workaround
          ];
        };
        # zoom = {
        #   executable = "${lib.getBin pkgs.zoom-us}/bin/zoom";
        #   extraArgs = [
        #     "--noblacklist=/home/${user}/.librewolf"
        #     "--whitelist=/home/${user}/.librewolf/profiles.ini"
        #     "--read-only=/home/${user}/.librewolf/profiles.ini"
        #   ];
        # };
        brave = {
          executable = "${lib.getBin pkgs.brave}/bin/brave --enable-features=UseOzonePlatform --enable-wayland-ime";
        };
        librewolf = {
          executable = "${lib.getBin pkgs.librewolf}/bin/librewolf";
          extraArgs = [
            "--dbus-user.talk=org.fcitx.Fcitx5" # TODO: look into this workaround
          ];
        };
        drawio = {
          executable = "${lib.getBin pkgs.drawio}/bin/drawio --enable-features=UseOzonePlatform --enable-wayland-ime";
          extraArgs = [
            "--whitelist=/home/${user}/box/work/drawio"
          ];
        };
      # End of wrappedBinaries
      };
    };
    # DE
    hyprland.enable = true;
    # Enable network monitoring
    iftop.enable = true;
    wireshark.enable = true;
    # End of program
  };

  security = {
    rtkit.enable = true; # Bluetooth realtime kit
    pam.services.hyprlock = {}; # Enable hyprlock to use PAM
    # app security
    apparmor = {
      enable = true;
      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };
    sudo.wheelNeedsPassword = false; # NoPasswd needed for wheel
    # End of security
  };

  services = {
    blueman.enable = true;
    # Sound
    # TODO: Bluetooth hfp still not working properly
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
    # USB mounting support
    devmon.enable = true;
    gvfs.enable = true; 
    udisks2.enable = true;
    # Enable laptop bat auto-tune
    # powerManagement.powertop.enable = true;
    tlp.enable = true;
    # End services
  };

  # TimeZone
  time.timeZone = "America/Los_Angeles";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    ${user} = {
      # VOLATILE: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoj8qO2mdeopNwZQohpiuYnFN+P2Cb5dtOLvCultWg/ user"
      # ];
      # VOLATILE: Be sure to add any other groups you need (such as networkmanager, etc)
      extraGroups = ["wheel" "networkmanager" "wireshark"];
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Provide bin with set capabilities
  # [TODO] Does this add a lot of dependency? Strange
  # security.wrappers = {
  #   nethogs = {
  #     owner = "root";
  #     group = "root";
  #     capabilities = "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe";
  #     source = "${pkgs.iputils.out}/bin/nethogs";
  #   };
  # };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     # Opinionated: forbid root login through SSH.
  #     PermitRootLogin = "no";
  #     # Opinionated: use keys only.
  #     # Remove if you want to SSH using passwords
  #     PasswordAuthentication = false;
  #   };
  # };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
