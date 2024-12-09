{
  buildNpmPackage,
  fetchFromGitHub,
  remarshal,
  ttfautohint-nox,
}:
let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
in
buildNpmPackage rec {
  pname = "iosevka-zt";
  inherit (metadata) version npmDepsHash;

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    inherit (metadata) hash;
  };

  nativeBuildInputs = [
    remarshal
    ttfautohint-nox
  ];

  postPatch = ''
    cp -v ${./private-build-plans.toml} private-build-plans.toml
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets contents::${pname}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -avL dist/${pname}/* $out
    runHook postInstall
  '';
}
