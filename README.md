# Nix Config

Note for myself: No ricing. Reproducible dragon.

The goal is to set up reproducible config for quick boostrapping a new machine and run some experiments.

- [x] Generic laptop setup
- [x] Mac mini
- [x] Migrate cmdline tool configs from 2024
- [ ] Update installation instructions
- [ ] Macbook pro
- [ ] Split GUI apps between personal/testbed setup
- [ ] Arm pi setup
- [ ] Nix on droid
- [ ] Automate browser extension install

## Usage

### Installation

Refer to official wiki for up-to-date installation instructions.

### Update

```shell
# Package update
nix flake update
# Configuration update
# NixOS
sudo nixos-rebuild --flake .#hostname switch --show-trace
# Darwin
sudo darwin-rebuild --flake .#hostname switch --show-trace
```

## Device Notes

### Microsoft Surface GO 2

- (Overnight compile time) Use specific [nixos-hardware](https://wiki.nixos.org/wiki/Hardware/Microsoft/Surface_Go_2) kernel

### Mac

For mac, use home-manager to install and customize apps.
Leave the native system configurations (docks, etc.) to MacOS.

- [ ] Auto wireshark chmodpkg install?

## References

- One of the [nixos wiki](https://wiki.nixos.org/wiki/NixOS_system_configuration)
- [nix-darwin Github](https://github.com/nix-darwin/nix-darwin)
- Misterio77 [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- ryan4yin [nix-darwin config](https://github.com/ryan4yin/nix-darwin-kickstarter/)
- My hyprland NixOS setup [2024-setup](https://github.com/130e/nix-config/tree/2024-envysea)
