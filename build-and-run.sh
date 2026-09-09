docker build -t ebpf-class .
docker run -it --rm \
    --privileged \
    --pid=host \
    --network=host \
    ebpf-class \
    /bin/bash

