I'm using morgify to optimize this blog images using the following command: 
```shell
mogrify -resize "1000x1000>" -quality 80 -auto-orient -strip  <image-path>
```

Find all files larger than 1M and resize them (regardless of the type)
```shell
find public -type f -size +1M -exec mogrify -resize "1000x1000>" -quality 80 -auto-orient -strip {} \;
```

Find all jpg files larger than 1M
```shell
find public -type f -size +1M -iname *.jpg
```

Find all jpg files larger than 1M and resize them.
```shell
find public -type f -size +1M -iname *.jpg -exec mogrify -resize "1000x1000>" -quality 80 -auto-orient -strip {} \;
```

Find all jpg OR png files larger than 1M and resize them
```shell
find public -type f -size +1M \( -iname *.jpg -o -iname *.png \) -exec mogrify -resize "1000x1000>" -quality 80 -auto-orient -strip {} \;
```