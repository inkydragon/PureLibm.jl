# Gappa

> automatic proof generation of arithmetic properties
>
> https://gitlab.inria.fr/gappa/gappa

## Build and Install

```sh
# Build
cd ~
git clone https://gitlab.inria.fr/gappa/gappa.git
cd gappa
./autogen.sh 
./configure && ./remake -j
# verify
./src/gappa --version

# install
sudo ln -s ~/gappa/src/gappa  /usr/bin/gappa
```
