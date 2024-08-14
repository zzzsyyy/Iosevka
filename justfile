default:
  @just --summary --unsorted --justfile {{justfile()}}

alias u:=update
alias s:=show

update:
  @nix flake update

show:
  @nix flake show

