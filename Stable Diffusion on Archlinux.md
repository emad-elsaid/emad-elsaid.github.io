:framed_picture: #archlinux #AI #stable_diffusion

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
* Clone xformers `git clone https://github.com/facebookresearch/xformers.git` and cd into it
* Setup the rest of requirements
```
git submodule update --init --recursive
pip install -r requirements.txt
pip install -e .
```
* this last line shows an error: `ModuleNotFoundError: No module named 'torch'`