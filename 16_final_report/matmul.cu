#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>

#include "matmul.hpp"

__global__ void mat_mul(float *A, float *B, float *C, int size_x, int size_y)
{
	// these point to the first element of the first block we are considering
	float *a = A + blockIdx.y * BLOCK_SIZE * size_x;
	float *b = B + blockIdx.x * BLOCK_SIZE;
	float *c = C + blockIdx.y * BLOCK_SIZE * size_y + blockIdx.x * BLOCK_SIZE;


	int numBlocks = size_x / BLOCK_SIZE;

	float res;

	for (int i = 0; i < numBlocks; a += BLOCK_SIZE, b += BLOCK_SIZE * size_y, i++) {

		// now a and b point to the first element of the block we are considering

		__shared__ float sa[BLOCK_SIZE][BLOCK_SIZE];
		__shared__ float sb[BLOCK_SIZE][BLOCK_SIZE];

		sa[threadIdx.y][threadIdx.x] = a[size_x * threadIdx.y + threadIdx.x];
		sb[threadIdx.y][threadIdx.x] = b[size_y * threadIdx.y + threadIdx.x];

		__syncthreads();

		for (int j = 0; j < BLOCK_SIZE; j++) {
			res += sa[threadIdx.y][j] * sb[j][threadIdx.x];
			//printf("%f\t%f\n", sa[threadIdx.y][j] , sb[j][threadIdx.x]);
		}
		__syncthreads();
	}
	//printf("%d, %d, %d, %d, %f\n", threadIdx.x, threadIdx.y, blockIdx.x, blockIdx.y, res);
	//printf("%f\n", res);
	c[threadIdx.x + threadIdx.y * size_y] = res;
}

void h_mat_mul(dim3 grid, dim3 block, float *A, float *B, float *C, int size_x, int size_y) {
	mat_mul<<< grid, block >>>(A, B, C, size_x, size_y);
}
