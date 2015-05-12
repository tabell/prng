#include <stdio.h>
#include <math.h>

#define bits(x) (int)ceil(log2((double)((abs(x)))))

#define PRNG_PRINT

int div_mod(int y, int x, int mod);

int main(int argc, char** argv)
{
	int s;
	if (argc > 1) s = atoi(argv[1]);
	else s = 5;
	if ((s < 0) || (s > 2147483647)) s = 5;
	int i;
	int seed = s;
	int length = 1;
	 for (i =0;i<length;i++)
	{
		s = prng(16807,2147483647,s);
		printf("random number, seed = %i --> %i\n",seed,s);
		
	}
	int a = 65535;
	int b = 32768;

	printf("test: %i\n",-20%3);
	
	// printf("%i %% %i = %i\n",a,b,div_mod(a,b,1));
	// printf("%i / %i = %i\n",a,b,div_mod(a,b,0));
}

int prng(int a, int m, int seed)
{
	// stage 1
	int q = div_mod(m,a,0);
	#ifdef PRNG_PRINT
	printf("q=%i\n",q);
	#endif
	int r = div_mod(m,a,1);
	#ifdef PRNG_PRINT
	printf("r=%i\n",r);
	#endif
	// stage 2
	int s0 = seed;
	int y = div_mod(s0,q,1);
	#ifdef PRNG_PRINT
	printf("y=%i\n",y);
	#endif
	int z = div_mod(s0,q,0);
	#ifdef PRNG_PRINT
	printf("z=%i\n",z);
	#endif
	// rest of stages
	int mult1_result = (a*y);
	#ifdef PRNG_PRINT
	printf("m1=%i\n",mult1_result);
	#endif
	int mult2_result = (r*z);
	#ifdef PRNG_PRINT
	printf("m2=%i\n",mult2_result);
	#endif
	int sub_result = mult1_result - mult2_result;
	#ifdef PRNG_PRINT
	printf("sub=%i\n",sub_result);
	#endif
	return div_mod(sub_result,m,1);
}

int div_mod(signed int y, signed int x, signed int mod)
{
	if (mod) return y % x;
	else return y / x;
}
int div_mod2(int y, int x, int mod)
{
	// printf("Algorithm 1 simulation\n");
	int init_y=y;
	int init_x = x;
	int i=0,z=0,u=0;
	int d;
	// int nm=31-(int)ceil(log2((double)x));
	int nm = bits(y)-bits(x);
	// printf("Dividing %i / %i\n",y, x );
	// printf("log2(x) = %i\t log2(y) = %i \n",bits(x),bits(y));
	if (nm < 0) {
		z = 0;
	}
	else {
	do {
		d = 1<<(nm-i);
		if (y >= 0) u = 1;
		else u = -1;
		y -= u*d*x;
		z += u*d;
		// printf("iteration %i: d = 2^%i=%i \t z = %i \t y = %i (%i bits) \t dx = %i\n",i,nm-i,d,z,y,bits(y),d*x);
		i=i+1;
	// } while (i <= 31-(int)ceil(log2((double)x)));
	} while (i <= nm);
	if (y > x) {
		y-=x;
		z += 1;
	}
	if (y < 0) {
		// printf("y = %i, need to fix\n",y);
		y += x;
		// printf("y = %i\n",y);

		// printf("z = %i, need to fix\n",z);
		z -=1;
		// printf("z = %i\n",z);
	}

}

		// } while ((abs(y) > x) || (y*x > 0));
	// printf("y = %i\n",y);
	// printf("d*x = %i\n",(1<<14)*x);
	// printf("d*x-y = %i\n",(1<<14)*x-y);
	if (!mod) return z;
	else return y;
}