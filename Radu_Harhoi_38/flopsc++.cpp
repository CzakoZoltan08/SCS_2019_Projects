#include <iostream>
#include <time.h>
#include <math.h>

using namespace std;

int floatingPointOperations (int n) {
    int total = 0;
    for(int i=0; i<n; i++){
        float a, b;
        int t = clock();
        a *= b;
        total += clock() - t;
    }

    return total;
}

int main ()
{
  clock_t t;
  int n = 10000000;

  t = floatingPointOperations(n);

  cout<<n<<" flops performed in "<<((float)t)/CLOCKS_PER_SEC<<" seconds";
  return 0;
}
