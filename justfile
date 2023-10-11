#!/usr/bin/env -S just --justfile

[private]
default:
  @just --list --justfile {{justfile()}} --list-heading $'Avalible Commands\n'

new name:
  npx hygen presentation new --name {{name}}

demo *project:
  just -f {{project}}/justfile demo

present *project:
  just -f {{project}}/justfile present
