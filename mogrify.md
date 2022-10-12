I'm using morgify to optimize this blog images using the following command: 

```shell
mogrify -resize "1000x1000>" -quality 80 -auto-orient -strip  <image-path>
```