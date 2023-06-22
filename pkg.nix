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
            weights = {
              light = {
                shape = 300;
                menu = 300;
                css = 300;
              };
              regular = {
                shape = 400;
                menu = 400;
                css = 400;
              };
              medium = {
                shape = 500;
                menu = 500;
                css = 500;
              };
              semibold = {
                shape = 600;
                menu = 600;
                css = 600;
              };
              bold = {
                shape = 700;
                menu = 700;
                css = 700;
              };
            };
          };
          set = "zt";
        }).overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.zip ];
          dontInstall = true;
          postBuild = ''
            WORKDIR="$PWD"
            mkdir -p $out
            zip "$WORKDIR/iosevka.zip" dist/*/ttf/*
            cp -av "$WORKDIR/iosevka.zip" $out
          '';
        });
      };
    };
}
