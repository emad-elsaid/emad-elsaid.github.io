* A list of choices that can simplify my life as a developer
* It also make other developers life easier when interacting with my software


# Project names
* Choose simple name 
* a Name that reflect what the project solves
* Plain name instead of marketing

Examples:
* Library (a project to manage my physical bookshelf)
* Debugger (a Golang debugger interface)
* Go-Server (golang server common code)

Avoid names like:
* Mau (social application concept) : too thematic
* Xlog (static site generator, and note-taking)
* Amun (Emacs implementation in Ruby)


# Dependencies
* Avoid depending on multiple programming languages in the same project
* Avoid depending on packages that have other dependencies
* Avoid depending on third-party packages as much as possible

# Code naming
* in Golang prefers a flat structure instead of a nesting package
* Prefer one or two-word classes/struct names instead of long names


# Code complexity 
* Avoid writing unneeded abstractions unless it serves the function or it's reused
* Reduce the code to the minimum that covers the use case
* Sacrifice minimal project features if it leads to greater simplicity in the project code
* Avoid complicated language features and prefer simple control structures, and functions.
* Be conscious of which parts of the code are data and which parts are transformation/logic

Every line of code adds complexity. every function, struct, or class. module, package, and programming language. so to have simpler projects I aim to introduce fewer of them.