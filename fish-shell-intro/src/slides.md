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

# Friendly Interactive Shell

Installation, Configuration and Usage

<!--
How long have I been using fish?

Feel free to interrupt me at any time with questions.

-->

---
---

# What is a shell?

---
transition: slide-up
---
# What is a Terminal?

---
---

# What is a shell?
<v-clicks>

- Runs in a terminal
- Interprets commands

</v-clicks>

<!-- 
Is this needed?
-->

---
---
# The Why of fish shell
- A shell for human interaction
- There are problems when maintaining POSIX compatibility

<!-- 
sh - 1971

Posix - 1988

bash - 1989

fish - 2005
-->
---
---
# Installation
https://fishshell.com/

### Options

<v-clicks>

1. Change Login shell
2. Set terminal Emulators Shell
3. Launch from POSIX Shell on start
4. Launch from shell manually when needed

</v-clicks>

---
---
# Configuration
<v-click>

`set --universal fish_greeting`

</v-click>

---
---
# Usage
- Right Arrow - suggestion competition (Alt+→)
- Tab - Tab Competition
- Alt + s - super user do `sudo !!`
- Alt + p -  pager `!! &| less`
- Alt + e - open command in editor

---
---
# Plugins

https://github.com/jorgebucaran/fisher

---
---
# Configuration in depth
`cd ~/.config/fish/`
<v-clicks>

- `conf.d/**.fish`
- `config.fish`

</v-clicks>
---
---
# Some Differences

<v-clicks>

- PATH
  - `fish_path_add`
- Universal Variables
  - `set -U EDITOR vim`
- `string` builtin

</v-clicks>

---
---
# Abbreviations

`abbr -a gco git checkout`

