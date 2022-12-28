:framed_picture: #archlinux #AI #stable_diffusion

# Stability AI Stable Diffusion

* Repo on Github: https://github.com/Stability-AI/stablediffusion
* Clone repo then cd into it
* Installed Anaconda first `yay -S anaconda`
* Activate anaconda env `source /opt/anaconda/bin/activate root`
* Install pytorch `conda install pytorch==1.12.1 torchvision==0.13.1 -c pytorch`
* Install required packages `pip install transformers==4.19.2 diffusers invisible-watermark`
* Got this error
```
ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
daal4py 2021.6.0 requires daal==2021.4.0, which is not installed.
numba 0.55.1 requires numpy<1.22,>=1.18, but you have numpy 1.24.1 which is incompatible.
```
* Installed daal manually `pip install daal==2021.4.0`
* run `pip install -e .`
* Download https://huggingface.co/stabilityai/stable-diffusion-2-1/blob/main/v2-1_768-ema-pruned.ckpt I didn't know about HuggingFace
* Install Cuda `sudo pacman -S cuda`
* to install xformers
```
export CUDA_HOME=/opt/cuda
sudo conda install -c nvidia/label/cuda-11.4.0 cuda-nvcc
sudo conda install -c conda-forge gcc
sudo conda install -c conda-forge gxx_linux-64==9.5.0
```
* I added sudo because without sudo I got this error
```
EnvironmentNotWritableError: The current user does not have write permissions to the target environment.
  environment location: /opt/anaconda
  uid: 1000
  gid: 1000
```
* Previous commands took too long to finish (couple hours). I'm now sure where the slowness is coming from. I noticed it's maxing out 1 logical CPU out of 16 :frowning_face:
* Clone xformers https://github.com/facebookresearch/xformers and cd into it
* Setup the rest of requirements
```
git submodule update --init --recursive
pip install -r requirements.txt
sudo pip install -e .
```
* this last line shows an error: `ModuleNotFoundError: No module named 'torch'` so I ran `sudo conda install pytorch` then `sudo pip install -e .`
* I got some errors of missing packages so
```
pip install omegaconf
pip install torchvision
pip install pytorch_lightning
pip install pytorch-lightning
pip install open_clip_torch
```
* I got another error that prompted me to run this `sudo python setup.py build develop`
* also found error about missing triton so `pip install triton==2.0.0.dev20221120`
* created a dir `output` and ran
```
python scripts/txt2img.py --prompt "a professional photograph of an astronaut riding a horse" --ckpt v2-1_768-ema-pruned.ckpt --config configs/stable-diffusion/v2-inference-v.yaml --H 768 --W 768  --outdir output
```
* I got an error
```
making attention of type 'vanilla-xformers' with 512 in_channels
building MemoryEfficientAttnBlock with 512 in_channels...
Killed
```
* tried reducing number of steps and other params but I got the same error
```
python scripts/txt2img.py --prompt "a professional photograph of an astronaut riding a horse" --ckpt v2-1_768-ema-pruned.ckpt --config configs/stable-diffusion/v2-inference-v.yaml --ddim_eta 0.0 --n_samples 3 --n_iter 3 --scale 5.0  --steps 100 --H 192 --W 192 --outdir output
```

/info I guess at this point I should give up on this approach and try another setup like this one https://github.com/basujindal/stable-diffusion

# Docker compose fork for CompVis Stable Diffusion

- cloned this repo and cd into it `gh repo clone basujindal/stable-diffusion`
- moved the model to another directory `mv ../stablediffusion/v2-1_768-ema-pruned.ckpt ../sd-data/model.ckpt`
- Install nvidia-container-toolking `yay -S nvidia-container-toolkit`
- uncomment `no-cgroups = false` in `/etc/nvidia-container-runtime/config.toml`
- and restart docker `sudo systemctl restart docker`
- I had to update my machine at this point as it couldn't install `bmake` so that's another 4gb or downloads and 14gb installation side. :smiling_face_with_tear:
- build the containers `docker-compose build`
- and run the containers `docker-composer run`
- I got an error, it seems the model for Stable Diffusion from Stability won't work on the CompVis version. so I downloaded the latest version from their model https://huggingface.co/CompVis
- then run `docker-composer run` again.
- I got this interface

![Gradio](/public/6720597cbea41ccc5a61989b06a3c54b878f9e46de7333b252481c8b8b4fdbe4.png)

# Well it works finally

![](/public/eed5b36fee1d3cbac505a18afe2c18ae5af5c6595d8aa1de68d406d267991606.png)