Nsight-Systems-Docker-Image


docker build -f nsight-systems.Dockerfile --no-cache --tag=nsight-systems:11.4 .

xhost +
docker run -it --rm --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --cap-add=SYS_ADMIN --security-opt seccomp=unconfined -v $(pwd):/mnt --network=host nsight-systems:11.4
xhost -
