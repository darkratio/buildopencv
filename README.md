## buildOpenCV

Script for building OpenCV 4.6-dev

* **Building for:

Ubuntu

20.04, 22.04

OpenCV 4.6.0

Packaging Option ( Builds package by default; --no\_package does not build package)

Building

$ ./buildOpenCV.sh

$ make -j$nproc

Build Parameters

OpenCV is a very rich environment, with many different options available. Check the script to make sure that the options you need are included/excluded. By default, the buildOpenCV.sh script selects these major options:

CUDA on

GStreamer

V4L - (Video for Linux)

QT - (No gtk support built in)

Python 3 bindings

Packaging

By default, the build will create a OpenCV package. The package file will be found in:

opencv/build/\_CPACK\_Packages/Linux/STGZ/OpenCV-4.6.0-<commit>-amd64.sh

The advantage of packaging is that you can use the resulting package file to install this OpenCV build on other machines without having to rebuild. Whether the OpenCV package is built or not is controlled by the CMake directive CPACK\_BINARY\_DEB in the script.

Notes

feel free to give your feedback!!
