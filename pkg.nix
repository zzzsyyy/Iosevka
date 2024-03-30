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
            noCvSs = false;
            exportGlyphNames = true;
            variants = {
              inherits = "ss05";
              design = {
                capital-q = "crossing";
                capital-u = "toothless-corner-serifless";
                a = "single-storey-tailed";
                i = "serifed-flat-tailed";
                lower-delta = "flat-top";
                lower-lambda = "tailed-turn";
                lower-xi = "flat-top";
                zero = "oval-slashed";
                three = "flat-top-serifless";
                ampersand = "upper-open";
                percent = "rings-continuous-slash-also-connected";
              };
            };
            widths = {
              Condensed = {
                shape = 500;
                menu = 3;
                css = "condensed";
              };
              Normal = {
                shape = 600;
                menu = 5;
                css = "normal";
              };
              Extended = {
                shape = 720;
                menu = 7;
                css = "expanded";
              };
            };
            ligations.inherits = "dlig";
            weights = {
              Light = {
                shape = 300;
                menu = 300;
                css = 300;
              };
              Regular = {
                shape = 400;
                menu = 400;
                css = 400;
              };
              Medium = {
                shape = 500;
                menu = 500;
                css = 500;
              };
              Semibold = {
                shape = 600;
                menu = 600;
                css = 600;
              };
              Bold = {
                shape = 700;
                menu = 700;
                css = 700;
              };
            };
          };
          set = "zt";
        }).overrideAttrs (old: {
          dontInstall = true;
          postBuild = ''
            mkdir -p $out
            tar caf "$out/Iosevka-${old.version}".tlz -C dist/* .
          '';
        });
      };
    };
}
