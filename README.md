# newsched-docker
Docker image for demonstrating newsched

## Building the docker
```
docker build -t newsched-demo ./
```

## Running with CUDA support
```
docker run --network=host --gpus all -it --rm -v `pwd`:/workspace/code newsched-demo bash
```

## Running an example OOT on the docker
```
docker run -it newsched-demo
cd prefix
source setup_env.sh
cd src
git clone https://github.com/mormj/ns-howto.git
cd ns-howto
meson setup build --prefix=/prefix 
cd build
ninja
ninja install
ninja test
```