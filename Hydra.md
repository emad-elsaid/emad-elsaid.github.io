#sideproject  #youtube

https://www.youtube.com/watch?v=g25cW4_XW6I

# Problem
+ I use spacemacs, which is centered around Hydra
+ Over the years I built muscle memory that's very useful and fast inside Emacs BUT it's worthless in other applications
+ the next application that I spend most of my time in is the Terminal
+ I would like to make this muscle memory useful in the terminal as much as possible

# Finding 
+ Bash has a `bind` [command](https://www.man7.org/linux/man-pages/man1/bash.1.html#:~:text=bind%20%5B%2Dm%20keymap%5D%20%5B%2DlpsvPSVX%5D) which utilizes readline library key bindings
+ So I can bind a program to `space` key just like spacemacs
+ Unfortunately, this means pressing `space` at any time it'll trigger the program/function
  + To solve this I need it to run only if the line is empty.
  + Pressing `space` when the terminal is empty doesn't have any use case for me
  + Then I can bind the `space` key to shell function that trigger the program only if the line is empty
  + Stackoverflow [helped with this](https://stackoverflow.com/questions/76916813/bash-completion-with-space-key-only-if-the-line-is-empty)


# Solution
+ A small program that displays the tree of command similar to Hydra
+ The configuration can be read from a file or more
+ If the user chooses a command the program can execute it
+ Bind `space` key in the shell to shell function
+ The function checks if the line is empty and runs the command

# Issues
+ if I want the command to change the shell's current working directory it will not work
  + because a process that executes `system` runs the command in a subshell that exists after the command exists
  + so `cd` will work inside the subshell and the user's original shell will have the same original working directory
+ The solution is to
  + Not to execute the command inside the program
  + Print the command and eval it from the shell function
  + Print the UI to stderr instead of stdout to separate the UI output from the command that needs to pass down to the shell to eval it.

# Tech stack

+ I wanted an excuse to practice C again and this program seems to be simple enough
+ I used GnuMake to compile and install the program
+ I'm using Bash so anyone with Zsh probably will need to change the shell script 

# Conclusion
+ It was very useful to develop this program for me to get back to C
+ binding `ls` to `space` in Hydra means that I can press `space` twice in any directory and I'll get the current directory contents.

# References
+ Program website https://hydra.emadelsaid.com/
+ Github repo https://github.com/emad-elsaid/hydra


