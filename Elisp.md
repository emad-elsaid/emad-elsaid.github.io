To bring up the documentation on your machine 
```
$ info elisp
```

# Tips

- `M-x ielm` : interactive shell, feels better than `M-x eshell` 
- [System crafters](https://www.youtube.com/c/SystemCrafters) youtube channel has a list of videos for Elisp

# Equality

- `eq` is it same object?
- `eql` same parameter or same number?
- `equal` equivelant values

# Sequences

- `length` get length
- `elt` get element in index `(elt '(1 2 3) 2)`  = 3
- `aset` set index value

# Strings

- `make-string` make string of length N filled with character

# Conditionals

- `not`, `and`, `or`
- `if`, `when`, `unless`

# Functions

- `defun` define function