# Nix Config

The goal is to set up reproducible config for quick boostrapping a new machine and run some experiments.

- [x] Generic laptop setup
- [x] Mac mini
- [x] Migrate cmdline tool configs from 2024
- [ ] Update installation instructions
- [x] Split GUI apps between personal/testbed setup
- [ ] Proper cpp development env
- [ ] Macbook pro
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

In retrospect, the first reason that I switched to mac is because macbook has excellent battery and touchpad (for its price).
The second reason is compatiblity with commercial apps. It works well with binary release like zoom-us and wechat.

However, using nix-darwin kind of counter the seond point a bit.
If homebrew does not build for older MacOS.
And Macport sometimes requires building package myself.

**Note:** There is an [issue] using zsh with home-manager config in MacOS, due to how MacOS handles PATH with [path_helper](https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2).
It's not easy to reproduce. So I'll just keep this in mind.

## References

- One of the [nixos wiki](https://wiki.nixos.org/wiki/NixOS_system_configuration)
- [nix-darwin Github](https://github.com/nix-darwin/nix-darwin)
- Misterio77 [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- ryan4yin [nix-darwin config](https://github.com/ryan4yin/nix-darwin-kickstarter/)
- My hyprland NixOS setup [2024-setup](https://github.com/130e/nix-config/tree/2024-envysea)
