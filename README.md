Dota 2 Bot Scripts
==================

Still a work in progress but have a look around. Works only with abilities and items usage for a few number of bots. 


Bots so far
===========

- Axe: Works like a charm. Blink, blademail, kill.

![bots gif](bots.gif "Axe is Axe")

- Sven
- Shadow Shaman
- Lion
- Earthshaker


Getting Started
===============

Before you clone the repo rename the old bot scripts directory and create a new directory

```bash
$ botsDir=$DOTA\steamapps\common\dota 2 beta\game\dota\scripts\vscripts\bots
$ mv $botsDir $botsDir.old
$ mkdir $botsDir
```

Edit the `abilities_usage.lua` to build abilities and `item_usage` to 
