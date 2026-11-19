#!/bin/sh
cd "$(dirname "$0")"
x86_64-w64-mingw32-g++ -std=c++17 -O2 -shared -static -static-libgcc -static-libstdc++ \
  -IB21_EFM -Iinclude -o ../bin/B21_EFM.dll B21_EFM/B21_EFM.cpp
