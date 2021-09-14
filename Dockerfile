# FROM ubuntu:20.04
FROM nvcr.io/nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

# ENV security_updates_as_of 2021-08-31

# Prepare distribution
RUN apt-get update -q \
    && apt-get -y upgrade

# CPP deps
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -qy \
    libzmq3-dev \
    doxygen \
    libspdlog-dev \
    libyaml-cpp-dev \
    libgtest-dev \
    libfmt-dev \
    pybind11-dev \
    python3-dev \
    python3-numpy \
    --no-install-recommends \
    && apt-get clean


# Build deps
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    --no-install-recommends \
    build-essential \
    ccache \
    ninja-build \
    libboost-dev \
    libboost-program-options-dev \
    libboost-thread-dev \
    libfftw3-dev \
    libgmp-dev \
    libgsl0-dev \
    doxygen \
    doxygen-latex \
    libqwt-qt5-dev 

# Testing deps
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -qy \
    xvfb \
    lcov \
    python3-scipy \
    python3-pyqt5 \
    --no-install-recommends \
    && apt-get clean

# Install other dependencies (e.g. VOLK)
RUN apt-get -y install -q \
    git \
    python3-pip \
    cmake \
    pkg-config \
    ca-certificates \
    --no-install-recommends
RUN apt-get clean
RUN apt-get autoclean

RUN pip install meson ninja mako six jinja2 pyyaml

# Useful tools
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -qy vim

# Install VOLK
RUN mkdir -p /src/build
RUN git clone --recursive https://github.com/gnuradio/volk.git /src/volk --branch v2.4.1
RUN cd /src/build && cmake -DCMAKE_BUILD_TYPE=Release ../volk/ && make && make install && cd / && rm -rf /src/


# Create a Prefix
RUN mkdir /prefix
RUN mkdir /prefix/src
COPY setup_env.sh /prefix/

# Clone and build cusp
ENV LIBRARY_PATH ${LD_LIBRARY_PATH}:${LIBRARY_PATH}
ENV PATH="/prefix/bin:$PATH"
ENV PYTHONPATH="/prefix/lib/python3/site-packages:/prefix/lib/python3/dist-packages:/prefix/lib/python3.8/site-packages:/prefix/lib/python3.8/dist-packages:/prefix/lib64/python3/site-packages:/prefix/lib64/python3/dist-packages:/prefix/lib64/python3.8/site-packages:/prefix/lib64/python3.8/dist-packages:$PYTHONPATH"
ENV LD_LIBRARY_PATH="/prefix/lib:/prefix/lib64/:/prefix/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
ENV LIBRARY_PATH="/prefix/lib:/prefix/lib64/:/prefix/lib/x86_64-linux-gnu:$LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/prefix/lib/pkgconfig:/prefix/lib64/pkgconfig:$PKG_CONFIG_PATH"
ENV PYBOMBS_PREFIX="/prefix"

RUN echo ${LIBRARY_PATH}
RUN ln -s /usr/local/cuda/lib64/libcudart.so /usr/lib/libcudart.so
RUN cd /prefix/src/ && git clone https://github.com/gnuradio/cusp.git
RUN cd /prefix/src/cusp && meson setup build --prefix=/prefix --libdir=lib && cd build && ninja && ninja install

# Clone and build newsched
RUN cd /prefix/src/ && git clone https://github.com/gnuradio/newsched.git
RUN cd /prefix/src/newsched && meson setup build --prefix=/prefix --libdir=lib -Denable_cuda=true && cd build && ninja && ninja install

WORKDIR /workspace/code