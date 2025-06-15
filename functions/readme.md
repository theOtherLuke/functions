# Function Files
Each file contains a function that may be called from the command line or the configuration for that function respectively.
## Usage
In my .bashrc I added this
```
for file in ~/functions/*; do
    source "$file"
done
```
Now, all these functions are available from the cli when I'm running bash.


###
---
I recently found BreadOnPenguins on youtube. Bread's work has inspired me to play around with creating modular functions I can add to my shell. A few of these are just because I like making things 'go'. A few may be incredibly useful, like set-display, which was directly inspired by Bread's dimmer script. Like set-display, many of these functions are directly inspired by Bread's work, as well as the work of others. Thank you Bread and others! Now for my daily Bread ;)
