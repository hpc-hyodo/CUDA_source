#include <stdio.h>
#include "FFT.h"
#define N 16 /* NÇÕ2ÇÃÇ◊Ç´èÊ */

// 7787285617673431 * 100712375473872ÇÃåvéZ 
void main(void)
{
	int i, j, rgsi, cy = 0, radix = 10000, ip[N / 2 + 2], ans[N + 2];
	double scale, a[N + 2], b[N + 2], c[N + 2], w[N / 2 + 2], rgs, gr;

	for (i = 0; i<N; i++) a[i] = 0.0;
	a[N - 4] = 7787.0;
	a[N - 3] = 2856.0;
	a[N - 2] = 1767.0;
	a[N - 1] = 3431.0;

	for (i = 0; i<N; i++) b[i] = 0.0;
	b[N - 4] = 100.0;
	b[N - 3] = 7123.0;
	b[N - 2] = 7547.0;
	b[N - 1] = 3872.0;

	ip[0] = 0;
	rdft(N, 1, a, ip, w);
	rdft(N, 1, b, ip, w);

	c[0] = a[0] * b[0];
	c[1] = a[1] * b[1];
	for (i = 2; i<N; i += 2){
		c[i] = a[i] * b[i] - a[i + 1] * b[i + 1];
		c[i + 1] = a[i + 1] * b[i] + a[i] * b[i + 1];
	}

	rdft(N, -1, c, ip, w);

	scale = 2.0 / N;
	gr = 1.0 / radix;
	ans[0] = 0;
	for (i = N - 1; i>0; i--){
		rgs = c[i - 1] * scale + 0.5 + cy;
		cy = rgs*gr;
		rgsi = rgs;
		ans[i] = rgsi - cy*radix;
	}

	for (i = 0; i<N; i++) printf("%04d", ans[i]);
	printf("\n");
}
