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
# enable presenter notes
presenter: true
# use UnoCSS
css: unocss
---


# The Home of a Nerd

---

## Core Principals

1. My Family Lives here
2. This is needs to be fun
3. It should be useful

---

## High Level

```mermaid
%%{ init: { 'flowchart': { 'curve': 'linear' } } }%%
flowchart
    isp[ISP]
    router[Router]
    isp --> router
    switch[switch]
    router --> switch
    ap1[AP]
    ap2[AP]
    switch --> ap1
    switch --> ap2
    server1[Server]
    server2[Server]
    server3[Server]
    switch --> server1
    switch --> server2
    switch --> server3
```
