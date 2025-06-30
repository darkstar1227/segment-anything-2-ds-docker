FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-devel

# Install git and dos2unix
RUN apt-get update && apt-get install -y git \
    dos2unix \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0

# Set CUDA architecture flags
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX"

# Set the working directory
WORKDIR /sam2

# Clone the repository
RUN git clone https://github.com/facebookresearch/sam2.git .

# # Remove existing setup.py and copy custom one
# RUN rm setup.py
# COPY setup.py .
# ENV PIP_NO_SSL_VERIFY=1
# RUN echo -e "[system_default_sect]\nMinProtocol = TLSv1.2\nCipherString = DEFAULT:@SECLEVEL=1" > /etc/ssl/openssl.cnf

# # Install dependencies
RUN python -m pip install --upgrade pip
RUN pip cache purge
RUN SAM2_BUILD_ALLOW_ERRORS=0 pip install --no-cache-dir -v -e ".[dev]"
RUN pip install --no-cache-dir torch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 --index-url https://download.pytorch.org/whl/cu121
RUN pip install --no-cache-dir ninja 
RUN python /sam2/setup.py build_ext --inplace

# Download checkpoints
RUN dos2unix ./checkpoints/download_ckpts.sh

RUN chmod +x ./checkpoints/download_ckpts.sh && \
    cd checkpoints && \
    ./download_ckpts.sh || echo "Checkpoint download failed, continuing anyway"

