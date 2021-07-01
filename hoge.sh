#!/bin/bash

echo_red() {
    echo "${ESC}[3;21;31m$1${ESC}[m"
}

# ESC=$(printf '\033')
ESC=$(printf '\033')
echo "${ESC}[31mRED${ESC}[m"
echo_red hoge
echo_red "test failed!"
