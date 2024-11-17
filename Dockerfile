FROM python:3.8.20-bookworm

# Fix: ImportError: libGL.so.1: cannot open shared object file: No such file or directory
RUN apt-get update -y && apt-get -y install ffmpeg libsm6 libxext6

# Create the outputs folder
RUN mkdir -p outputs

# Install pip ffmpeg
RUN pip install ffmpeg-python

# Install PyTorch
RUN pip install torch==1.7.1 -f https://download.pytorch.org/whl/torch_stable.html

# Install torchvision
RUN pip install https://download.pytorch.org/whl/torchvision-0.17.0-cp38-cp38-linux_aarch64.whl#sha256=e041ce3336364413bab051a3966d884bab25c200f98ca8a065f0abe758c3005e

# Install facexlib
RUN pip install facexlib

# Install gfpgan
RUN pip install gfpgan

# Copy files from source to the container
COPY . /Real-ESRGAN

# Set root at Real-ESRGAN
WORKDIR /Real-ESRGAN

# Install all remain packages
RUN pip install -r requirements.txt

# Setup develop
RUN python setup.py develop

# Clean up all cached files
RUN pip cache purge && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT [ "python" ]
