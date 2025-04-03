default:
  @just --summary --unsorted --justfile {{justfile()}}

alias u:=update
alias s:=show

update-flake:
  @nix flake update

show:
  @nix flake show

update-hash:
  #!/usr/bin/env bash
  set -xeuo pipefail

  latest_version=$(curl -s "https://api.github.com/repos/be5invis/Iosevka/releases/latest" | jq --raw-output '.tag_name | sub("^v"; "")')
  json_output=$(nix run nixpkgs#nix-prefetch-git -- --url "git@github.com:be5invis/Iosevka" --rev "v$latest_version" --quiet | jq)
  hash=$(echo "$json_output" | jq -r '.hash')
  jq --arg version "$latest_version" \
     --arg hash "$hash" \
     '.version = $version | .hash = $hash' \
     ./metadata.json | tee ./metadata.json.tmp
  mv ./{metadata.json.tmp,metadata.json}
