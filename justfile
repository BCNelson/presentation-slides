#!/usr/bin/env -S just --justfile

[private]
default:
  @just --list --justfile {{justfile()}} --list-heading $'Avalible Commands\n'

new name:
  npx hygen presentation new --name {{name}}
