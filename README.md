# Nsight Systems Docker Image

## Introduction

This is a portable Nsight Systems Docker image which allows the user to profile executables anywhere using the Nsight Systems inside the Docker container.

## Usages

### Build Docker Image

To build the Docker image, please run the following command.

```bash
$ docker build -f nsight-systems.Dockerfile --no-cache --tag=nsight-systems:2023.4 .
```

### Run Docker Container

To run the Docker container, please run the following command.

```bash
$ xhost +
$ docker run -it --rm --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --cap-add=SYS_ADMIN --security-opt seccomp=unconfined -v $(pwd):/mnt --network=host nsight-systems:2023.4
$ xhost -
```

### Build Examples

```bash
$ cd $(pwd):/mnt/examples
$ nvcc async_non_pinned_memory.cu -o async_non_pinned_memory
$ nvcc async_pinned_memory.cu -o async_pinned_memory
```

### Run Nsight Systems

```bash
$ nsys-ui
```

### Run Nsight Compute

```bash
$ ncu-ui
```
