#!/bin/bash
# License: MIT. See license file in root directory
# Copyright(c) Darkratio

######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN #
######################################

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='4.6.0'       # Version to be installed
OPENCV_CONTRIB='YES'          # Install OpenCV's extra modules (YES/NO)
# -------------------------------------------------------------------- |

# |          THIS SCRIPT IS TESTED CORRECTLY ON          |
# |------------------------------------------------------|
# | OS               | OpenCV       | Test | Last test   |
# |------------------|--------------|------|-------------|
# | Ubuntu 22.04 LTS | OpenCV 4.6.0 | OK   | 04 Oct 2022 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.5.4 | OK   | 10 Dec 2021 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.5.1 | OK   | 27 Mar 2021 |
# |----------------------------------------------------- |
# | Ubuntu 20.04 LTS | OpenCV 4.2.0 | OK   | 25 Apr 2020 |
# |----------------------------------------------------- |
# | Debian 10.2      | OpenCV 4.2.0 | OK   | 26 Dec 2019 |
# |----------------------------------------------------- |
# | Debian 10.1      | OpenCV 4.1.1 | OK   | 28 Sep 2019 |


# 1. KEEP UBUNTU OR DEBIAN UP TO DATE

sudo apt-get -y update
sudo apt-get -y upgrade       # Uncomment to install new versions of packages currently installed
sudo apt-get -y dist-upgrade  # Uncomment to handle changing dependencies with new vers. of pack.
sudo apt-get -y autoremove    # Uncomment to remove packages that are now no longer needed

# 2. INSTALL THE DEPENDENCIES

# Build tools:
sudo apt install build-essential cmake pkg-config unzip yasm git checkinstall

# GUI (if you want GTK, change 'qt5-default' to 'libgtkglext1-dev' and remove '-DWITH_QT=ON'):
sudo apt-get install libgtk-3-dev

# Image I/O libs
$ sudo apt install libjpeg-dev libpng-dev libtiff-dev

# Video/Audio Libs - FFMPEG, GSTREAMER, x264 etc:
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev
sudo apt-get install libfaac-dev libvorbis-dev

# OpenCore - Adaptive Multi Rate Narrow Band (AMRNB) and Wide Band (AMRWB) speech codec:
sudo apt-get install libopencore-amrnb-dev libopencore-amrwb-dev

# Parallelism library C++ for CPU
sudo apt-get install libtbb-dev

# Python libraries for python3:
$ sudo apt-get install python3-dev python3-pip
$ sudo -H pip3 install -U pip numpy
$ sudo apt install python3-testresources

# Optimization libraries for OpenCV
sudo apt-get install libatlas-base-dev gfortran

# Optional libraries:
sudo apt-get install libprotobuf-dev protobuf-compiler
sudo apt-get install libgoogle-glog-dev libgflags-dev
sudo apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
sudo apt-get install libgtkglext1 libgtkglext1-dev
sudo apt-get install libopenblas-dev liblapacke-dev libva-dev libopenjp2-tools libopenjpip-dec-server libopenjpip-server libqt5opengl5-dev libtesseract-dev 

# Install Ceres Solver
sudo apt-get install cmake libeigen3-dev libgflags-dev libgoogle-glog-dev libsuitesparse-dev libatlas-base-dev libmetis-dev

git clone https://github.com/darkratio/ceres-solver.git
cd ceres-solver && mkdir build && cd build
cmake ..
make -j
make test
sudo make install


# Download OpenCV and OpenCV Contrib. In June 2022, the 4.6.0 release didn’t include the fix to compile properly with the latest Ceres release. Cloning and building 4.6.0-dev from the repos includes the fix. Future OpenCV releases shouldn’t have this issue.

wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV

if [ $OPENCV_CONTRIB = 'YES' ]; then
  wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
  unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
  mv opencv_contrib-${OPENCV_VERSION} opencv_contrib
fi

cd OpenCV && mkdir build && cd build

# Build and Install OpenCV

#CMake config options description
#CUDA_ARCH_BIN corresponds to the compute capability for the graphics card listed on NVIDIA’s site.
#QT has more features than GTK. When OPENGL is used, RGBD failed to compile with OpenGL_GL_PREFERENCE=GLVND, so OpenGL_GL_PREFERENCE=LEGACY is needed.

if [ $OPENCV_CONTRIB = 'NO' ]; then
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D OPENCV_PC_FILE_NAME=opencv.pc \
	-D WITH_TBB=ON \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=7.5 \
	-D WITH_CUBLAS=1 \
	-D WITH_OPENGL=ON \
	-D WITH_QT=ON \
	-D OpenGL_GL_PREFERENCE=LEGACY \
	-D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.10/dist-packages \
	-D PYTHON_EXECUTABLE=/usr/bin/python3.10 \
	-D BUILD_EXAMPLES=ON ..
fi

if [ $OPENCV_CONTRIB = 'YES' ]; then
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D OPENCV_PC_FILE_NAME=opencv.pc \
	-D WITH_TBB=ON \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=7.5 \
	-D WITH_CUBLAS=1 \
	-D WITH_OPENGL=ON \
	-D WITH_QT=ON \
	-D WITH_LIBV4L=ON \
	-D WITH_V4L=ON \
    	-D WITH_GSTREAMER=ON \
    	-D WITH_GSTREAMER_0_10=OFF \
	-D OpenGL_GL_PREFERENCE=LEGACY \
	-D BUILD_opencv_python3=ON \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-D BUILD_EXAMPLES=ON \
	$"PACKAGE_OPENCV" ..
fi

if [ $? -eq 0 ] ; then
  echo "CMake configuration make successful"
else
  # Try to make again
  echo "CMake issues " >&2
  echo "Please check the configuration being used"
  exit 1
fi

# Consider the MAXN performance mode
time make -j$NUM_JOBS
if [ $? -eq 0 ] ; then
  echo "OpenCV make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "Make did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  make
  if [ $? -eq 0 ] ; then
    echo "OpenCV make successful"
  else
    # Try to make again
    echo "Make did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi

echo "Installing ... "
sudo make install
sudo ldconfig
if [ $? -eq 0 ] ; then
   echo "OpenCV installed in: $CMAKE_INSTALL_PREFIX"
else
   echo "There was an issue with the final installation"
   exit 1
fi

# If PACKAGE_OPENCV is on, pack 'er up and get ready to go!
# We should still be in the build directory ...
if [ "$PACKAGE_OPENCV" != "" ] ; then
   echo "Starting Packaging"
   sudo ldconfig  
   time sudo make package -j$NUM_JOBS
   if [ $? -eq 0 ] ; then
     echo "OpenCV make package successful"
   else
     # Try to make again; Sometimes there are issues with the build
     # because of lack of resources or concurrency issues
     echo "Make package did not build " >&2
     echo "Retrying ... "
     # Single thread this time
     sudo make package
     if [ $? -eq 0 ] ; then
       echo "OpenCV make package successful"
     else
       # Try to make again
       echo "Make package did not successfully build" >&2
       echo "Please fix issues and retry build"
       exit 1
     fi
   fi
fi
