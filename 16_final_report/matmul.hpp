#include <cuda.h>
#include <cuda_runtime.h>

#define BLOCK_SIZE 16
//#define BLOCK_SIZE 1

#define checkError(invocation) do { if (invocation != cudaSuccess) std::cout << "cuda error at " << __FILE__ << ":" << __LINE__ << std::endl;} while (0)

void h_mat_mul(dim3 grid, dim3 block, float *A, float *B, float *C, int size_x, int size_y);
