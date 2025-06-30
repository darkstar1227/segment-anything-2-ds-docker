FROM pytorch/pytorch:2.5.0-cuda12.4-cudnn9-devel

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

# # Install dependencies
RUN pip uninstall -y SAM-2 && \
    rm -f ./sam2/*.so && \
    SAM2_BUILD_ALLOW_ERRORS=0 pip install -v -e ".[interactive-demo]"
RUN pip install --no-cache-dir ninja pycocotools
RUN python /sam2/setup.py build_ext --inplace

# Download checkpoints
RUN dos2unix ./checkpoints/download_ckpts.sh

RUN chmod +x ./checkpoints/download_ckpts.sh && \
    cd checkpoints && \
    ./download_ckpts.sh || echo "Checkpoint download failed, continuing anyway"
#TODO:Change to web demo
# Run jupyter notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]