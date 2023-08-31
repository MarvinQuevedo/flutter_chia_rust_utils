
docker build . -t rust_cross_compile/amd64 -f Dockerfile.amd64  
docker run --rm -ti -v `pwd`/chia_rust_utils:/home/chia_rust_utils   rust_cross_compile/amd64
 