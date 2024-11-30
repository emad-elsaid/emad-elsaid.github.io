Thanks to [Christian](https://community.sony.at/t5/tipps-tutorials-faqs/sony-kameras-als-webcam-unter-linux-nutzen-howto/ba-p/3697384) for the guide, here is the gist:

# Prepare the camera
* Ctrl. with smartphone -> off
* PC remote control -> on
* USB setting -> PC remote control

# Prepare the machine
1. install packages
```shell
sudo apt install ffmpeg gphoto2 v4l2loopback-dkms v4l2loopback-utils
```
2. Load the kernel module
```shell
sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
```
3. Check the camera is detected
```shell
➜ gphoto2 --auto-detect
Model                          Port                                            
----------------------------------------------------------
Sony ILCE-6400 (PC Control)    usb:001,017
```
4. Take one still picture just to be sure it works
```shell
gphoto2 --capture-image-and-download
```
5. Redirect the video to virtual camera
```shell
# Without hardware acceleration
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
# With hardware acceleration (I have a NVIDIA RTX 2060)
gphoto2 --stdout --capture-movie | ffmpeg -hwaccel nvdec -c:v mjpeg_cuvid -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
```

# Tips
* I tried connecting the device to USB port in the front of the PC and the lag was high. connecting it to one of the back ports was faster. still laggy but less.
