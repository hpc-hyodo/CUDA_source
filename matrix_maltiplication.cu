//GPU並列計算　行列の乗算 1024*1024
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 1024

#define BLOCK_SIZE 32


struct Matrix
{
	int width;
	int height;
	float *elements;
};

__global__ void multMatrix(const float *a, const float *b, float *c)
{
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	int j = blockDim.y*blockIdx.y + threadIdx.y;
	int k;
	float v;

	v = 0.;
	for (k = 0; k < N; k++){
		v += a[i*N + k] * b[k*N + j];
		__syncthreads();
	}

	c[i*N + j] = v;
}


int main(void)
{
	float *a;
	float *b;
	float *c;
	float *a_d;
	float *b_d;
	float *c_d;
	dim3 grid;
	dim3 block;
	int i, j, k;
	unsigned int begin, end, begin2, end2;

	srand(time(NULL));

	cudaMallocHost(&a, N*N*sizeof(float));
	cudaMallocHost(&b, N*N*sizeof(float));
	cudaMallocHost(&c, N*N*sizeof(float));

	cudaMalloc(&a_d, N*N*sizeof(float));
	cudaMalloc(&b_d, N*N*sizeof(float));
	cudaMalloc(&c_d, N*N*sizeof(float));

	for (i = 0; i < N*N; i++){
		a[i] = (double)rand()/(RAND_MAX+1);
		b[i] = (double)rand() /(RAND_MAX + 1);
	}

	cudaMemcpy(a_d, a, N*N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(b_d, b, N*N*sizeof(float), cudaMemcpyHostToDevice);

	grid = dim3(N / BLOCK_SIZE, N / BLOCK_SIZE);
	block = dim3(BLOCK_SIZE, BLOCK_SIZE);
	
	begin = clock();
	multMatrix << <grid, block >> >(a_d, b_d, c_d);
	end = clock();

	cudaMemcpy(c, c_d, N*N*sizeof(float), cudaMemcpyDeviceToHost);
	begin2 = clock();
	for (i = 0; i < N; i++){
		for (j = 0; j < N; j++){
			float v;
			v = 0.;
			for (k = 0; k < N; k++){
				v += a[i*N + k] * b[k*N + j];
			}
			if (fabs((c[i*N + j] - v) / v) > 1e-5){
				printf("error\n");
				goto loop_end;
			}
		}
	}
loop_end:
	end2 = clock();
	
	//for (i = 0; i < N*N; i++){
	//	printf("c[%d] = %.f \n", i, c[i]);
	//}
	printf("BLOCK_SIZE:%d\n", BLOCK_SIZE);
	printf("Number of block in grid：%d\n", (N / BLOCK_SIZE)* (N / BLOCK_SIZE));
	printf("Number of thread in block：%d\n", BLOCK_SIZE * BLOCK_SIZE);
	printf("Total Number of thread: %d\n", (BLOCK_SIZE*BLOCK_SIZE)*((N / BLOCK_SIZE)* (N / BLOCK_SIZE)));
	printf("CPU計算時間：%d(ms)\n", end2 - begin2);
	printf("GPU計算時間：%d(ms)", end - begin);

	cudaFreeHost(a);
	cudaFreeHost(b);
	cudaFreeHost(c);

	cudaFree(a_d);
	cudaFree(b_d);
	cudaFree(c_d);

	return 0;
}