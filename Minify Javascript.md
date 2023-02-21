* install `uglify-js`
* list js files and minify each separately

```shell
find . -type f \
    -name "*.js" \
    -exec echo {} \; \
    -exec cp {} {}.old \; \
    -exec uglifyjs -o {} {}.old \; \
    -exec rm {}.old \;
```