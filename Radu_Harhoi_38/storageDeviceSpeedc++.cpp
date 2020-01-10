#include <time.h>
#include <math.h>
#include <fstream>
#include <iostream>

using namespace std;

ifstream fin(".in");
ofstream fout(".out");

int main ()
{
  clock_t t1=0, t2=0, auxt1, auxt2;
  int n = 1000000;
  char c;

  for(int i=0; i<n; i++){
    auxt1 = clock();
    fin>>c;
    t1 += clock() - auxt1;

    auxt2 = clock();
    fout<<c;
    t2 += clock() - auxt2;
  }

  cout<<n<<" bytes read in "<<((float)t1)/CLOCKS_PER_SEC<<" seconds\n";
  cout<<n<<" bytes written in "<<((float)t2)/CLOCKS_PER_SEC<<" seconds\n";

  fin.close();
  fout.close();
  return 0;
}
