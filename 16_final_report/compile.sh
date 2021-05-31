#!/usr/bin/env bash

set -x

mpicxx -Wall -std=c++11 -I/apps/t3/sles12sp2/cuda/10.2.89/include -c example.cpp -o example.o
nvcc -c matmul.cu -o matmul.o
mpicxx -Wall matmul.o example.o -lcudart
