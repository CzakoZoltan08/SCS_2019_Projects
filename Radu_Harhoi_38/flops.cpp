#include <iostream>
#include <time.h>
#include <math.h>

#include <intrin.h>
#define constant 1 / 159720

 #include <fstream>


using namespace std;
ofstream fout("results.txt");

int floatingPointOperations(int n) {
    int total = 0;
    for (int i = 0; i < n; i++) {
        float a = 15.28, b = 23.7;
        int t = __rdtsc();
        a *= b;
        total += __rdtsc() - t;
    }

    return total;
}

int main()
{
    uint64_t t;
    int n = 10000000;

    for (int i = 0; i < 100; i++) {
        t = floatingPointOperations(n) * constant;

        fout << ((float)t) / CLOCKS_PER_SEC << '\n';
    }

    //cout << n << " flops performed in " << ((float)t) / CLOCKS_PER_SEC << " seconds";
    return 0;
}
