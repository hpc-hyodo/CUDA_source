//CPUを使ったベクトル加算
#include <stdio.h>
#include <time.h>

#define N 10240
#define M 100000

void addVector(const float *a, const float *b, float *c)
{
	int i;
	for (i = 0; i < N; i++){
		c[i] = a[i] + b[i];
	}
}

int main(void)
{
	float *a;
	float *b;
	float *c;
	int i;
	unsigned int begin, end;

	srand(time(NULL));

	a = (float *)malloc(N*sizeof(float));
	b = (float *)malloc(N*sizeof(float));
	c = (float *)malloc(N*sizeof(float));

	for (i = 0; i < N; i++){
		a[i] = rand() / (float)RAND_MAX;
		b[i] = rand() / (float)RAND_MAX;
	}

	begin = clock();
	for (i = 0; i < M; i++){
		addVector(a, b, c);
	}
	end = clock();
	for (i = 0; i < N; i++){
		if (c[i] != a[i] + b[i]){
			printf("error\n");
			break;
		}
	}
	
	printf("計算時間は%d(ms)です\n", end - begin);

	free(a);
	free(b);
	free(c);

	return 0;
}
