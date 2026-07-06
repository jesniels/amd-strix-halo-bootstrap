toolbox create llama-rocm-7.2.2 \
  --image docker.io/kyuz0/amd-strix-halo-toolboxes:rocm-7.2.2 \
  -- --device /dev/dri --device /dev/kfd \
  --group-add video --group-add render --group-add sudo --security-opt seccomp=unconfined
