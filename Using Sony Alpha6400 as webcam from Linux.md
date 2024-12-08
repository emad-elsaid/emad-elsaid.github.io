Thanks to [Christian](https://community.sony.at/t5/tipps-tutorials-faqs/sony-kameras-als-webcam-unter-linux-nutzen-howto/ba-p/3697384) for the guide, here is the gist:

# Using USB cable

## Prepare the camera
* Ctrl. with smartphone -> off
* PC remote control -> on
* USB setting -> PC remote control

## Prepare the machine
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

## Tips
* I tried connecting the device to USB port in the front of the PC and the lag was high. connecting it to one of the back ports (USB 3.1 Gen2) was faster. still laggy but less.
* Also I have 2 RTX2060, 1 of them is connected to the monitor. I used the other for ffmpeg hardware acceleration by adding `-hwaccel_device 1` for ffmpeg commang. (I got an overview of the cards usage with `nvidia-smi` command). This reduces the lag

# Using capture card

This is what gave me the least lag. I recommend it over the USB cable

## Hardware

* I'm using Mirabox (the older version of [this](https://www.amazon.de/Portable-Recorder-Streaming-Superior-Technologie-Rot/dp/B07G84G7VF))
* Micro-HDMI cable (Micro not Mini, I made a mistake when I got this cable and now I have a mini HDMI cable I have no use of)
* HDMI dummy

## Prepating the camera
* turn on Clean HDMI output

## Software
* v4l2loopback seems to be needed. however I didn't install anything after the setup the first method.

## Setup
1. Connect the camera with micro-HDMI to the capture card
2. Connect the dummy to the capture card
3. Connect the capture card to the PC using your fastest possible USB port.
4. Connect the camera to the USB and to a power brick. as HDMI won't give it power.
5. Connect a microphone to the camera if you need to or use stand-alone microphone connected to your PC.
6. Turn on the camera.
7. Now you should see a new web cam connected to your PC with your capture card name on it.

```shell
sudo v4l2-ctl --device=/dev/video0 --all
Driver Info:
	Driver name      : uvcvideo
	Card type        : MiraBox Video Capture : MiraBox
	Bus info         : usb-0000:02:00.0-7.1.3.4
	Driver version   : 6.12.1
	Capabilities     : 0x84a00001
		Video Capture
		Metadata Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : uvcvideo
	Model            : MiraBox Video Capture : MiraBox
	Serial           : 20000130041415
	Bus info         : usb-0000:02:00.0-7.1.3.4
	Media version    : 6.12.1
	Hardware revision: 0x00000100 (256)
	Driver version   : 6.12.1
Interface Info:
	ID               : 0x03000002
	Type             : V4L Video
Entity Info:
	ID               : 0x00000001 (1)
	Name             : MiraBox Video Capture : MiraBox
	Function         : V4L2 I/O
	Flags            : default
	Pad 0x01000007   : 0: Sink
	 Link 0x02000010: from remote pad 0x100000a of entity 'Extension 4' (Video Pixel Formatter): Data, Enabled, Immutable
Priority: 2
Video input : 0 (Camera 1: ok)
Format Video Capture:
	Width/Height      : 1920/1080
	Pixel Format      : 'MJPG' (Motion-JPEG)
	Field             : None
	Bytes per Line    : 0
	Size Image        : 4147200
	Colorspace        : sRGB
	Transfer Function : Rec. 709
	YCbCr/HSV Encoding: ITU-R 601
	Quantization      : Default (maps to Full Range)
	Flags             : 
Crop Capability Video Capture:
	Bounds      : Left 0, Top 0, Width 1920, Height 1080
	Default     : Left 0, Top 0, Width 1920, Height 1080
	Pixel Aspect: 1/1
Selection Video Capture: crop_default, Left 0, Top 0, Width 1920, Height 1080, Flags: 
Selection Video Capture: crop_bounds, Left 0, Top 0, Width 1920, Height 1080, Flags: 
Streaming Parameters Video Capture:
	Capabilities     : timeperframe
	Frames per second: 60.000 (60/1)
	Read buffers     : 0
```
