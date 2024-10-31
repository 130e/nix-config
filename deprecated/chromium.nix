# Deprecated: old chromium config
# Chromium moves to manifest V3
{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs = {
    chromium = {
      enable = true;
      # [Bug] chromium does not respect NIXOS_OZONE_WL=1
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      package = pkgs.ungoogled-chromium;
      # TODO: Can/should I skip sha256? Or, how do I pin crx version
      # NOTE: manually download plugin
      # Ref: https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore
      # Ref: https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214
      # url = https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=[VERSION]&x=id%3D[EXTENSION_ID]%26installsource%3Dondemand%26uc
      # Fill in chromium VERSION and EXTENSION_ID
      extensions =
        let
          createChromiumExtensionFor =
            browserVersion:
            {
              id,
              sha256,
              version,
            }:
            {
              inherit id;
              crxPath = builtins.fetchurl {
                url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                name = "${id}.crx";
                inherit sha256;
              };
              inherit version;
            };
          createChromiumExtension = createChromiumExtensionFor (
            lib.versions.major pkgs.ungoogled-chromium.version
          );
        in
        [
          (createChromiumExtension {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            sha256 = "sha256:39ec73ac4c77cde2b51f852e8ee9e51d079a110d2204962b20770264209bf0c0";
            version = "1.60.0";
          })
          (createChromiumExtension {
            # Vimium
            id = "dbepggeogbaibhgnhhndojpepiihcmeb";
            sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
            version = "2.1.2";
          })
          (createChromiumExtension {
            # Privacy badger
            id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
            sha256 = "sha256:1f0483a03a92466bbdc47c05eac81931ea6d54f32851f7c8e55cb62ff651584b";
            version = "2024.7.17";
          })
          (createChromiumExtension {
            # Dark Reader
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sha256 = "sha256:f7cb060a8d9d1be5d833305e2d1fb5d087390cb8c35e14a1d43cdab4b382c904";
            version = "4.9.95";
          })
        ];
      # If not using ungoogled-chromium:
      extensions = [
        # updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3D[EXTENSION_ID]%26uc";
        # Static declare extension. Need manually updating
        # uBlock Origin
        {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26uc";
        }
        # vimium
        {
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          updateUrl = "https://clients2.google.com/service/update2/crx?response=updatecheck&x=id%3Ddbepggeogbaibhgnhhndojpepiihcmeb%26uc";
        }
      ];
    };
  };
}
