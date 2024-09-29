# Me
{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    username = "simmer";
    homeDirectory = "/home/simmer";
  };

  home.packages = with pkgs; [
    # Sync
    nextcloud-client
  ];

  services.syncthing.enable = true;

  # Nextcloud netrc
  # TODO: Find a better way to integrate .netrc
  # NOTE: Set real credential after install
  # .netrc
  # home.file.".netrc".text = ''default
  #   login FIXME
  #   password FIXME
  # '';

  home.file."Nextcloud/sync-exclude.lst".text = ''
    .direnv/
    .git/
  '';

  systemd.user = {
    services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud";
        After = "network-online.target";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --exclude /home/simmer/Nextcloud/sync-exclude.lst --path /Documents /home/simmer/Nextcloud/Documents/ https://prevrain.simmer.work"; # NOTE: server addr
        TimeoutStopSec = "180";
        KillMode = "process";
        KillSignal = "SIGINT";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };

    timers.nextcloud-autosync = {
      Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
      Timer.OnBootSec = "5min";
      Timer.OnUnitActiveSec = "60min";
      Install.WantedBy = [
        "multi-user.target"
        "timers.target"
      ];
    };
  };
}
