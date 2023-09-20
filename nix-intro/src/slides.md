---
# try also 'default' to start simple
theme: default
# apply any windi css classes to the current slide
class: 'text-center'
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# page transition
transition: slide-left
---

# Nix A New Obsession

Oh soooo many things to learn

---

# What is nix?
<div style="font-size: 1.5em;">
<v-clicks>

- Nix is a package manager
- Nix is a language
- Nix is a build system
- Nix is a deployment tool
- Nix is a configuration management tool
- Nix is a container tool
- Nixos is a linux distribution
- It's a lot

</v-clicks>
</div>

---

# The Why <v-click><span>(The Boring Part)</span></v-click>

<div class="larger-text">
<v-clicks>

- Deterministic
- Reproducible

</v-clicks>
</div>

---

# The Why (The Fun Part) <v-click><span>For me</span></v-click>

<div class="larger-text">
<v-clicks>

- Config As Code
- Config for everything

</v-clicks>
</div>

<style>
.larger-text {
    font-size: 2em;
}
</style>

---
transition: fade
---

# Home Manager

```nix{|1|4-5}
{ config, pkgs, ... }:

{
  home.username = "bcnelson";
  home.homeDirectory = "/home/bcnelson";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
```

---



# Home Manager

```nix
{ config, pkgs, ... }:

{
  #...

  home.packages = with pkgs; [
    firefox
    git
    neovim
    ripgrep
    tmux
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "kwrite";
  };
}
```
---

# Nix Language
## Basic Types
```nix
"Hello World"
''
  Hello World
  This is a multi line string
''
"hello ${ { a = "world"; }.a }"
```
```nix
true, false
null
123
3.1415
```
```nix
/etc
~/.config
./dest
```
---

# Nix Language
## Lists
```nix
[ 1 2 3 ]
[ 'a' 'b' 'c' ]
[ 1 'a' true ]
```

## Sets
```nix
{ a = 1; b = 2; }
{ foo.bar = 1; } 
{ foo = {
    bar = 1; 
  };
}
```

---

# Nix Language
## Operators
```nix
1 + 2
"foo" + "bar"
"foo" == "f" + "oo"
```

---

# Nix Language
## Functions
```nix
x: x + 1

toString 3.1415 # "3.1415"

(x: x + 1) 100 # 101

(x: y: x + y) 100 200 # 300

({ a, b }: a + b) { a = 100; b = 200; } # 300
```

---

# Nix Flakes

```nix{all|2|3-5|6-8}
{
  description = "Example simple flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };
  outputs = { nixpkgs }: {
    defaultPackage.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.hello;
  };
}
```

<!--
The primary purpose of flakes are too make nix more reproducible and deterministic, by controlling the inputs
As such flakes are made of three parts a description, inputs, and outputs. The description is a string that describes the flake.
The inputs a nix set that contains the inputs to the flake. The output is a function that takes the inputs and returns a set of outputs.
The nix command line tools have also been rewritten to support flakes.
-->

---
transition: fade
---

# Home Manager Flake

`flake.nix`
```nix {all|2|3-9|10-19} {maxHeight: '90%', lines: true}
{
  description = "Example home-manager flake";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # Available through 'home-manager --flake .#bcnelson@vm-1'
    homeConfigurations = {
      "bcnelson@vm-1" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
```

---

# Home Manager Flake

`./home-manager/home.nix`

```nix {all|3} {maxHeight: '90%', lines: true}
{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [ ./firefox.nix ];
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "bcnelson";
    homeDirectory = "/home/bcnelson";
  };
  home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
}
```

---

# Home Manager Flake

`./home-manager/firefox.nix`

```nix {all} {maxHeight: '95%', lines: true}
{ pkgs, ... }:{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles = {
      personal = {
        name = "Personal";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          darkreader
        ];
        search = {
          default = "Google";
          force = true;
        };
        settings = {
          # Disable the builtin Password manager
          "signon.rememberSignons" = false;
          "signon.rememberSignons.visibilityToggle" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "trailhead.firstrun.didSeeAboutWelcome" = true;
};};};};} #<== I'm trying really hard to make this fit on one slide
```
---

# Devshells

```nix
{
  description = "A Nix-flake-based Node.js development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      overlays = [
        (final: prev: rec {
          nodejs = prev.nodejs_20;
          pnpm = prev.nodePackages.pnpm;
        })
      ];
      supportedSystems = [ "x86_64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
                nodejs
                pnpm
            ];
};});};}
```
