#include <time.h>
#include <math.h>
#include <fstream>
#include <iostream>

using namespace std;

ifstream fin(".in");
ofstream fout(".out");

int main ()
{
  clock_t t;
  int n = 1000000;
  char c;

  t = clock();
  for(int i=0; i<n; i++){
    fin>>c;
    fout<<c;
  }
  t = clock() - t;

  cout<<3*n<<" bytes transfered in "<<((float)t)/CLOCKS_PER_SEC<<" seconds";

  fin.close();
  fout.close();
  return 0;
}
