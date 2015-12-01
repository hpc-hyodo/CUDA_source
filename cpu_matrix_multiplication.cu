//CPUs—ñæZ@1024*1024

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <time.h>

#define N 1024

void multMatrix(const float *a, const float *b, float *c)
{
	int i, j, k;

	for (i = 0; i < N; i++){
		for (j = 0; j < N; j++){
			float v;
			v = 0.;
			for (k = 0; k < N; k++){
				v += a[i*N + k] * b[k*N + j];
			}
			c[i*N + j] = v;
		}
	}
}

int main(void)
{
	float *a;
	float *b;
	float *c;
	int i, j, k;
	unsigned int begin, end;

	srand(time(NULL));

	a = (float *)malloc(N*N*sizeof(float));
	b = (float *)malloc(N*N*sizeof(float));
	c = (float *)malloc(N*N*sizeof(float));

	for (i = 0; i < N*N; i++){
		a[i] = rand() / (float)RAND_MAX;
		b[i] = rand() / (float)RAND_MAX;
	}
	begin = clock();
	multMatrix(a, b, c);

	for (i = 0; i < N; i++){
		for (j = 0; j < N; j++){
			float v;
			v = 0.;
			for (k = 0; k < N; k++){
				v += a[i*N + k] * b[k*N + j];
			}
			if (c[i*N + j] != v){
				printf("error\n");
				goto loop_end;
			}
		}
	}
loop_end:
	end = clock();
	for (i = 0; i < N*N; i++){
		printf("c[%d] = %f \n", i, c[i]);
	}
	printf("Œv‘ªŠÔ‚Í%d‚Å‚·", end - begin);

	free(a);
	free(b);
	free(c);

	return 0;
}