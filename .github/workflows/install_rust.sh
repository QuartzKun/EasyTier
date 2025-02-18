#!/usr/bin/env bash

# env needed:
# - TARGET
# - GUI_TARGET
# - OS

# dependencies are only needed on ubuntu as that's the only place where
# we make cross-compilation
if [[ $OS =~ ^ubuntu.*$ ]]; then
    sudo apt-get update && sudo apt-get install -qq crossbuild-essential-arm64 crossbuild-essential-armhf musl-tools libappindicator3-dev llvm clang
    #  curl -s musl.cc | grep mipsel
    case $TARGET in
    mipsel-unknown-linux-musl)
        MUSL_URI=mipsel-linux-muslsf
        ;;
    mips-unknown-linux-musl)
        MUSL_URI=mips-linux-muslsf
        ;;
    aarch64-unknown-linux-musl)
        MUSL_URI=aarch64-linux-musl
        ;;
    armv7-unknown-linux-musleabihf)
        MUSL_URI=armv7l-linux-musleabihf
        ;;
    armv7-unknown-linux-musleabi)
        MUSL_URI=armv7m-linux-musleabi
        ;;
    arm-unknown-linux-musleabihf)
        MUSL_URI=arm-linux-musleabihf
        ;;
    arm-unknown-linux-musleabi)
        MUSL_URI=arm-linux-musleabi
        ;;
    esac

    if [ -n "$MUSL_URI" ]; then
        mkdir -p ./musl_gcc
        wget -c https://musl.cc/${MUSL_URI}-cross.tgz -P ./musl_gcc/
        tar zxf ./musl_gcc/${MUSL_URI}-cross.tgz -C ./musl_gcc/
        sudo ln -s $(pwd)/musl_gcc/${MUSL_URI}-cross/bin/*gcc /usr/bin/
        sudo ln -s $(pwd)/musl_gcc/${MUSL_URI}-cross/${MUSL_URI}/include/ /usr/include/musl-cross
    fi
fi

# see https://github.com/rust-lang/rustup/issues/3709
rustup set auto-self-update disable
rustup install 1.84
rustup default 1.84
rustup toolchain install nightly
rustup default nightly
rustup component add rust-src --toolchain nightly-x86_64-pc-windows-msvc

rustup target add x86_64-win7-windows-msvc
