#include <iostream>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <cstdlib>
#include <stdint.h>

#include <intrin.h>
#define constant 0.00035

#include <fstream>


using namespace std;
ofstream fout("results.txt");


int frequency_of_primes(int n) {
	int i, j;
	int freq = n - 1;
	for (i = 2; i <= n; ++i)
		for (j = sqrt(i); j > 1; --j)
			if (i % j == 0)
			{
				--freq; break;
			}
	return freq;
}

int main()
{

	int f, n = 100000;
	uint64_t t = __rdtsc();

	for (int i = 0; i < 100; i++) {
		t = __rdtsc();
		f = frequency_of_primes(n);
		t = __rdtsc() - t;

		fout << ((float)t) / CLOCKS_PER_SEC << '\n';
		//printf ("The number of primes lower than %d is: %d\n", n, f);
		//printf ("It took me %d clock cycles (%f seconds).\n",t,((float)t)/CLOCKS_PER_SEC);
	}
}


