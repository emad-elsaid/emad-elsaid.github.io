#youtube_video_idea

# Problem
+ Social media profiles are not owned spaces
+ Instagram doesn't show EXIF data
+ Unsplash is similar to social media. ownership is down the toilet

# Solutions
+ Use existing program that generate gallery
+ Write my own solution

# Solution
+ Write my own
  + To learn how to know more about EXIF
  + Improve my own website
  + Improve Xlog for other people to use
+ Write Xlog shotcode to read a directory and build timeline out of it
+ Every photo has a page with original size and some Exif data. not all

# Challenges
+ Github hosted pages limit is 1GB, and 100GB/month
  + I had to resize the images and compress them while keeping EXIF data
  + Find all files over 1MB where it's jpg or png
  + pass them all to mogrify and limit width and height to 1000 max
  + reduce quality to 80%
  + and rotate them according to the exif data rotation
```sh
find photos \
-type f \
-size +1M \( -iname *.jpg -o -iname *.png \) \
-exec mogrify \
-resize "1000x1000>" \
-quality 80 \
-auto-orient {} \;
```

# Implementation
+ Under 250 LoC https://github.com/emad-elsaid/xlog/blob/master/extensions/photos/photos.go
+ Example: Photography
+ Around a week

# Caveats
+ All images are in one page, resized and lazy loaded