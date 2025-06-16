# The Functions
I have only really tested any of these in bash, except for a *tiny* part of `set-display` that I tested in zsh.

place the files in `~/functions`

---
#### `fedit` and `_fedit_complete` - aka f(unction)edit

usage: `fedit <function>`

`fedit` is a quick way to edit any file in the `~/functions` directory regardless of what directory you are in. I have it setup to use nano. I've honestly just been too lazy to learn a different editor like vi(or its variants) or emacs. Just change the editor to that of your choice inside the `fedit` file. `fedit` also sources the freshly edited function file so you shouldn't have to reload your shell to make use of changes in the functions.

`_fedit_complete` implements command completion for files in `~/functions` so you can use tab at the command line to complete.

---
#### `set-display`

`set-display` is a function to quickly chage display brightness and gamma settings. There are also preconfigured flags for night/day modes. See the comment block inside the file for usage. Inspiration for this one comes from [@BreadOnPenguins](https://github.com/BreadOnPenguins), with a small piece from [@mdjames094](https://github.com/mdjames094)

---
#### `set-ps1`

`set-ps1` is my current method of setting my prompt. In `.bashrc` call it using `PROMPT_COMMAND=set-ps1`

---
#### `show-color`

`show-color` is used for showing colors based on the provided code. Flags include `-h <code>` for hex, `-2 <code>` for 256-color, and `-s <code>` for simple ANSI 8-color. See the comment block in the file for usage.

---
#### `weather` and `weather.conf`

`weather` is a simple implementation using wttr.in. `weather.conf` makes it possible to set location and temperature units.

---
#### `statusbar` and `statusbar.conf`

`statusbar` is my most ambitious work since my nordvpn scripts. This creates a status bar at the top of the terminal window that shows username@hostname, network, cpu, and ram usage, and the current time. It also works in ssh and xtermjs. This one is still a bit rough and needs some cleanup, but it *mostly* works. I say mostly because I haven't quite gotten notifications working yet.
