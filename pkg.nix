{inputs, lib, ...}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.napalm.overlays.default
      ];
    };

    packages = let
      plan = "iosevka-zt";
      nv = (pkgs.callPackage ./_sources/generated.nix {}).iosevka;
      version = lib.removePrefix "v" nv.version;
      mkZip = src: pkgs.runCommand "${src.pname}-${version}" {
          inherit src version;
          nativeBuildInputs = [
            pkgs.zip
          ];
        } ''
          WORKDIR="$PWD"
          cd $src
          zip "$WORKDIR/iosevka.zip" *
          cp -av "$WORKDIR/iosevka.zip" $out
        '';
    in {
      inherit (nv) src;

      ttf = pkgs.napalm.buildPackage nv.src {
        pname = "${plan}-ttf";
        inherit version;
        npmCommands = [
          "npm install"
          "npm run build --no-update-notifier -- ttf::iosevka-zt >/dev/null"
        ];
        nativeBuildInputs = [
          pkgs.ttfautohint
        ];
        postPatch = ''
          cp -v ${./private-build-plans.toml} private-build-plans.toml
        '';
        installPhase = ''
          mkdir -p $out
          cp -avL dist/*/ttf/* $out
        '';
      };

      default = mkZip config.packages.ttf;
    };
  };
}
