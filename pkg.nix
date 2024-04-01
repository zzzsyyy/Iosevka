{ inputs, lib, ... }: {

  perSystem =
    { pkgs
    , system
    , config
    , ...
    }:

    {
      packages = {
        default = (pkgs.iosevka.override {
          privateBuildPlan = (fromTOML (builtins.readFile ./private-build-plans.toml)).buildPlans.IosevkaZt;
          set = "zt";
        }).overrideAttrs (old: {
          dontInstall = true;
          postBuild = ''
            mkdir -p $out
            tar caf "$out/Iosevka-${old.version}".txz -C dist/* .
          '';
        });
      };
    };
}
