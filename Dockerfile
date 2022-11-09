# MIT License
#
# Copyright (c) 2022 Ignacio Vizzo
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
FROM ignaciovizzo/ros_in_docker:noetic
LABEL maintainer="Ignacio Vizzo <ignaciovizzo@gmail.com>"

# RUN pip install --no-cache cmake>=3.20

# Install Open3D dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libc++-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Open3D
RUN wget --no-verbose --show-progress --progress=dot:mega \
    https://github.com/isl-org/Open3D/releases/download/v0.16.0/open3d-devel-linux-x86_64-pre-cxx11-abi-0.16.0.tar.xz \
    && tar --xz -xvf open3d-devel-linux-x86_64-pre-cxx11-abi-0.16.0.tar.xz \
    && cp -r  /open3d-devel-linux-x86_64-pre-cxx11-abi-0.16.0/* /usr/local/ \
    && rm -rf /open3d-devel-linux-x86_64-pre-cxx11-abi-0.16.0*

# Install OpenVDB dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libblosc-dev \
    libboost-iostreams-dev \
    libboost-system-dev \
    libboost-system-dev \
    libeigen3-dev

# Install OpenVDB from source
RUN git clone --depth 1 https://github.com/nachovizzo/openvdb.git -b nacho/vdbfusion \
    && cd openvdb \
    && mkdir build && cd build \
    && cmake  -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DUSE_ZLIB=OFF .. \
    && make -j$(nproc) all install \
    && rm -rf /openvdb

# Install hidden dependencies, glog+gflags
RUN git clone https://github.com/gflags/gflags.git && cd gflags \
    && mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j$(nproc) all install \
    && rm -rf /gflags

RUN git clone -b v0.4.0 https://github.com/google/glog.git && cd glog \
    && mkdir build && cd build && cmake .. \
    && make -j$(nproc) all install \
    && rm -rf /glog

# Install extra ROS dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-noetic-tf2-sensor-msgs \
    && rm -rf /var/lib/apt/lists/*

# Install fmt library
RUN git clone --depth 1 https://github.com/fmtlib/fmt.git -b 6.2.0 && cd fmt \
  && mkdir build && cd build \
  && cmake .. && make -j all install \
  && rm -rf /fmt

# Install Open3D dependencies
RUN bash -c "$(curl -fsSL https://github.com/isl-org/Open3D/raw/v0.16.0/util/install_deps_ubuntu.sh)" "" assume-yes

# $USER_NAME Inherited from .base/Dockerfile
WORKDIR /home/$USER_NAME/ros_ws
CMD ["zsh"]
