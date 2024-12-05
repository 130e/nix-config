# Personal NixOS config

Base on [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/).

## To Fix

- nextcloudcmd netrc parse not working
  - Using GUI nextcloud now
- autotimezone failed due to geoclue2 not working in nixpkgs
  - Workaround `sudo timedatectl set-timezone EST`
- steam-run libGL: Can't open configuration file /etc/drirc
- gnome extension im-panel-integrated-with-osk is out of date
  - Using kimpanel for now
- wireshark bug: cannot save pcap due to filetype return undefined

## No-reproducibility Hack

- VSCodium FHS extensions
- [onlyoffice fonts](https://nixos.wiki/wiki/Onlyoffice)
- gnome extension config and shortcuts

## Desktop

Tired of configuring my DE and currently using gnome.

### GNOME

The gnome defaults are clean and pretty and I like to use wayland on touchscreen devices.

**TODOs**

- Install extension (could be declarative!)
- set up keyboard shortcuts declaratively

### Hyprland

Very satisfied with this WM. However currently I prefer to use a more integrated (bloated) DE that have more integration between APPs and better support for monitor switching.
