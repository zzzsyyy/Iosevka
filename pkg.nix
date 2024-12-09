{ inputs, lib, ... }:
{

  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:

    {
      packages = {
        default = (pkgs.callPackage ./base.nix { }).overrideAttrs (old: {
          dontInstall = true;
          postBuild = ''
            mkdir -p $out
            tar caf "$out/Iosevka-${old.version}".txz -C dist/* .
          '';
        });
      };
    };
}
