![](/public/d351208d0cfd9d195048de25ae8bc0c4415497afb45abfd53c6756c87a22214b.jpg)

#git

# Non-ASCII characters

Git escapes non-ASCII character by default, for example this garden has files in Arabic. `git ls-files` show them as follows:

```
science fiction.md
what are we sharing.md
"\330\243\330\263\331\201 \331\205\331\202\330\257\331\205\330\247.md"
"\330\247\330\260\331\203\330\261\331\210\330\247 \331\205\331\210\330\252\330\247\331\203\331\205.md"
"\330\247\330\263\330\252\330\255\331\210\330\247\330\260.md"
```

To have Git display names without escaping (which fixes other scripts that depends on the output)

```shell
git config --global core.quotepath false
```

Will have the output without escaping

```
science fiction.md
what are we sharing.md
أسف مقدما.md
اذكروا موتاكم.md
```

