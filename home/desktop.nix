{ ... }:
{
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
      # font.size = 14;
      # shellIntegration.enableZshIntegration = true;
    };

  };
}
