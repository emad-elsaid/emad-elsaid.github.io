![Blackmatter Modern Museum Berlin](/public/511db9be24235fa3babd7b73222b6959940ce2ece7c47a90de4e751f837b7ffe.jpg)

* A list of choices that can simplify my life as a developer
* It also makes other developers' life easier when interacting with my software


# Project names
* Choose a simple name 
* Name that reflects the function of the project
* Plain name instead of marketing

Good examples:
* Library (a project to manage my physical bookshelf)
* Debugger (a Golang debugger interface)
* Go-Server (golang server common code)

Bad examples:
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
* Avoid complicated language features and prefer simple control structures
* Be conscious of which parts of the code are data and which parts are transformation/logic

Every line of code adds complexity. every function, struct, or class. module, package, and programming language. so to have simpler projects I aim to introduce fewer of them.