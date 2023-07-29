Extract audio from video
```
ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac
```

Convert audio to wav
```
ffmpeg -y -i IMG_0277.aac -vn -acodec pcm_s16le IMG_0277.wav
```