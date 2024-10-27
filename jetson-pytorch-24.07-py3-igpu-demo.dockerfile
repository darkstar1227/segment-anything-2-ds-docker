FROM nvcr.io/nvidia/pytorch:24.07-py3-igpu

# Install git and dos2unix
RUN apt-get update && apt-get install -y git \
    dos2unix \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0

# Set the working directory
WORKDIR /sam2

# Clone the repository
RUN git clone https://github.com/facebookresearch/sam2.git .

# Install dependencies
RUN pip install --no-cache-dir numpy>=1.24.4 tqdm>=4.66.1 hydra-core>=1.3.2 iopath>=0.1.10 pillow>=9.4.0

# Demo Dependency
RUN pip install --no-cache-dir matplotlib opencv-python>=4.7.0 jupyter>=1.0.0

# Download checkpoints
RUN dos2unix ./checkpoints/download_ckpts.sh
RUN chmod +x ./checkpoints/download_ckpts.sh && \
    cd checkpoints && \
    ./download_ckpts.sh || echo "Checkpoint download failed, continuing anyway"

# Run jupyter notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]