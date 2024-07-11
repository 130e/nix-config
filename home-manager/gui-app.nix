{
  pkgs,
  config,
  ...
}: {
  programs = {
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      # package = pkgs.chromium.override {ungoogled = true;};
      package = pkgs.ungoogled-chromium;
    };

    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
  };

  home.packages = with pkgs; [
    telegram-desktop
    slack
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # [Optional] If you want to modify a .desktop entry
  # xdg.desktopEntries = {
  #   org.telegram.desktop.desktop = {
  #     name = "Telegram Desktop";
  #     comment = "Official desktop version of Telegram messaging app";
  #     exec = "telegram-desktop --enable-features=UseOzonePlatform --enable-wayland-ime";
  #     icon="telegram";
  #     terminal=false;
  #     type="Application";
  #     categories=["Chat" "Network" "InstantMessaging" "Qt"];
  #     mimeType=["x-scheme-handler/tg"];
  #     settings = {
  #       TryExec = "telegram-desktop";
  #       StartupWMClass="TelegramDesktop";
  #       Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
  #       DBusActivatable="true";
  #       SingleMainWindow="true";
  #       X-GNOME-UsesNotifications="true";
  #       X-GNOME-SingleWindow="true";
  #     };
  #     actions = {
  #       "quit" = {
  #         exec="telegram-desktop -quit";
  #         name="Quit Telegram";
  #         icon="application-exit";
  #       };
  #     };
  #   };
  # };
}
