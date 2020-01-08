#include <time.h>
#include <math.h>
#include <fstream>
#include <iostream>

#include <intrin.h>
#define constant 1 / 1635644

using namespace std;

ifstream fin("in.txt");
ofstream fout("out.txt");
ofstream rout("results.txt");

int main()
{
    uint64_t t1 = 0, t2 = 0, auxt1, auxt2;
    int n = 1000000;
    char c;

    for (int i = 0; i < 100; i++) {
        t1 = 0; t2 = 0;
        for (int i = 0; i < n; i++) {
            auxt1 = __rdtsc();
            fin >> c;
            t1 += __rdtsc() - auxt1;

            auxt2 = __rdtsc();
            fout << c;
            t2 += __rdtsc() - auxt2;
        }

        rout << ((float)t1 * constant) / CLOCKS_PER_SEC << '\n';
    }

    //cout << n << " bytes read in " << ((float)t1 * constant) / CLOCKS_PER_SEC << " seconds\n";
    //cout << n << " bytes written in " << ((float)t2 * constant) / CLOCKS_PER_SEC << " seconds\n";

    fin.close();
    fout.close();
    return 0;
}
