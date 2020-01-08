#include <stdio.h>
#include <time.h>
#include <math.h>

int frequency_of_primes (int n) {
  int i,j;
  int freq=n-1;
  for (i=2; i<=n; ++i)
    for (j=sqrt(i);j>1;--j)
        if (i%j==0)
        {
            --freq; break;
        }
  return freq;
}

int main ()
{
  clock_t t, avg;
  int f, n = 100000;

  for(int i=0; i<100; i++){
      t = clock();
      f = frequency_of_primes (n);
      avg += clock() - t;
  }

  avg /= 100;

  printf ("The number of primes lower than %d is: %d\n", n, f);
  printf ("It took me %d clock cycles (%f seconds).\n",avg,((float)avg)/CLOCKS_PER_SEC);
  return 0;
}
