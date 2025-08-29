{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
  ];

  programs = {

    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        # https://librewolf.net/docs/faq/#what-are-the-most-common-downsides-of-rfp-resist-fingerprinting
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting.overrides" = "+AllTargets,-CSSPrefersColorScheme";
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    # TOFIX: not available on darwin
    # chromium = {
    #   enable = true;
    #   commandLineArgs = [
    #     "--enable-features=UseOzonePlatform"
    #     "--enable-logging=stderr"
    #     "--enable-wayland-ime"
    #   ];
    #   package = pkgs.ungoogled-chromium;
    # };

    kitty = {
      enable = true;
      shellIntegration.mode = "enabled"; # TOFIX: not right
      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "cmd+w" = "close_tab";
      };
      settings = {
        font_size = 14;
        notify_on_cmd_finish = "unfocused";
        macos_option_as_alt = "yes";
      };
    };

  };

  services = {
    syncthing.enable = true;
  };
}
