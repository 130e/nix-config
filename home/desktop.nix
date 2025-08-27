{ pkgs, ... }:
{
  home.packages = with pkgs; [
  ];

  programs = {

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
      };
    };

  };

  services = {
    syncthing.enable = true;
  };
}
