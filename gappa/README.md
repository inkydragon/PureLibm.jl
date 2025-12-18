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

## References

- [User’s Guide for Gappa — Gappa documentation](https://gappa.gitlabpages.inria.fr/gappa/index.html)
- [Simon Tatham 2025, Formally verifying a floating-point division routine with Gappa – part 1](https://developer.arm.com/community/arm-community-blogs/b/embedded-and-microcontrollers-blog/posts/formally-verifying-a-floating-point-division-routine-with-gappa-p1)
- [Simon Tatham 2025, Formally verifying a floating-point division routine with Gappa – part 2](https://developer.arm.com/community/arm-community-blogs/b/embedded-and-microcontrollers-blog/posts/formally-verifying-a-floating-point-division-routine-with-gappa-p2)
- [Dinechin 2008, Certifying floating-point implementations using Gappa - Inria](https://inria.hal.science/ensl-00200830v1)
