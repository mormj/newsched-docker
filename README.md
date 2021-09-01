# newsched-docker
Docker image for demonstrating newsched

## Building the docker

## Running the docker


## setup_env.sh

needs to be dropped into the prefix

```
export PATH="/prefix/bin:$PATH"
export PYTHONPATH="/prefix/lib/python3/site-packages:/prefix/lib/python3/dist-packages:/prefix/lib/python3.8/site-packages:/prefix/lib/python3.8/dist-packages:/prefix/lib64/python3/site-packages:/prefix/lib64/python3/dist-packages:/prefix/lib64/python3.8/site-packages:/prefix/lib64/python3.8/dist-packages:$PYTHONPATH"
export LD_LIBRARY_PATH="/prefix/lib:/prefix/lib64/:/prefix/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export LIBRARY_PATH="/prefix/lib:/prefix/lib64/:/prefix/lib/x86_64-linux-gnu:$LIBRARY_PATH"
export PKG_CONFIG_PATH="/prefix/lib/pkgconfig:/prefix/lib64/pkgconfig:$PKG_CONFIG_PATH"
export PYBOMBS_PREFIX="/prefix"
```
