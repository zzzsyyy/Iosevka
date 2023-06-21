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
          privateBuildPlan = {
            family = "Iosevka ZT";
            spacing = "term";
            serifs = "sans";
            no-cv-ss = false;
            export-glyph-names = true;
            variants = {
              inherits = "ss05";
              design = {
                a = "single-storey-tailed";
                i = "serifed-flat-tailed";
                zero = "oval-tall-slashed";
                three = "flat-top";
                ampersand = "upper-open";
                percent = "rings-continuous-slash-also-connected";
              };
            };
            ligations.inherits = "dlig";
          };
          set = "zt";
        }).overrideAttrs (old: {
          installPhase = ''
            mkdir -p $out
            cp -avL dist/*/ttf/* $out
            runHook postInstall
          '';
          postInstall = ''
            WORKDIR="$PWD"
            cd $src
            zip "$WORKDIR/iosevka.zip" *
            cp -av "$WORKDIR/iosevka.zip" $out
          '';
        });
      };
    };
}
