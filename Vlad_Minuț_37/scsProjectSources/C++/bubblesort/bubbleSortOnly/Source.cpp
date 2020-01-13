#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;


void swap(int *a, int *b)
{
	int *aux;
	aux = a;
	a = b;
	b = aux;
}

void bubbleSort(int *arr, int n)
{
	int i, j;
	for (i = 0; i < n - 1; i++)
		for (j = 0; j < n - i - 1; j++)
			if (arr[j] > arr[j + 1])
				swap(arr[j], arr[j + 1]);
}

void print(int *arr, int n)
{
	cout << "The sorted array is: ";
	for (int i = 0; i < n; i++)
		cout << arr[i] << ' ';
}

int main()
{

	clock_t start, end;
	double cpu_time_used;
	int n;
	cout << "Please insert the size of the array: ";
	cin >> n;
	cout << endl;

	start = end=0;


	int arr[10001];


	cout << "Unsorted array: "<<endl;
	for (int i = 0; i < n; ++i)
	{
		//srand((unsigned)time(0));
		
		arr[i] = 1 + std::rand() / ((RAND_MAX + 1u) / 1000);
		cout <<" "<< arr[i] << endl;
	}
	start = clock();
	bubbleSort(arr, n);
	print(arr, n);
	end = clock();
	cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
	cout << cpu_time_used << " seconds";
	while (1);
	return 0;
}
