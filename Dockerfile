FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV CUDA_HOME=/usr/local/cuda-11.8 \
    CUDA_NVCC_EXECUTABLE=/usr/local/cuda-11.8/bin/nvcc \
    CUDA_PATH=/usr/local/cuda-11.8 \
    CUDAToolkit_ROOT=/usr/local/cuda-11.8

ENV PATH=${CUDA_HOME}/bin:${PATH} \
    CPATH=${CUDA_HOME}/include:${CPATH} \
    LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# ENV CUDA_HOME=/usr/local/cuda-11.8/ \
# CUDA_NVCC_EXECUTABLE=/usr/local/cuda-11.8/bin/nvcc \
# CUDA_PATH=${CUDA_HOME} CUDAToolkit_ROOT=${CUDA_HOME} \
# PATH=${CUDA_HOME}bin${PATH:+:${PATH}} \
# CPATH=${CUDA_HOME}include${CPATH:+:${CPATH}} \
# LD_LIBRARY_PATH=${CUDA_HOME}lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

ARG UID
ARG GID

RUN groupadd -g ${GID} devuser \
 && useradd -m -u ${UID} -g ${GID} devuser


RUN apt-get update && apt-get install -y python3.10 python3.10-dev python3-pip libsparsehash-dev

RUN ln -sf /usr/bin/python3.10 /usr/bin/python

USER root

RUN pip install --no-cache-dir torch==2.0.1+cu118 torchvision==0.15.2+cu118 --index-url https://download.pytorch.org/whl/cu118

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
