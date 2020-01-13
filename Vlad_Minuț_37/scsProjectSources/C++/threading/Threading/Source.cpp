#include <iostream>
#include <thread>
#include <ctime>
#include <vector>
#include <mutex>

using namespace std;

std::mutex lockMutex;

void numara(char *text, int pos1, int pos2, int * counter)
{
	for (int i = pos1; i < pos2; ++i)
		if (text[i] == 'a' || text[i] == 'e' || text[i] == 'i' || text[i] == 'o' || text[i] == 'u')
		{
			lockMutex.lock();
			(*counter)++;
			lockMutex.unlock();
		}
}

int main()
{
	char globaltext[100];
	int ctr, total, end, start, n;
	clock_t start_time, end_time, mid_time;
	double time_used, time_used_join;
	int stop;

	strcpy_s(globaltext, "To be measured text");

	cout << "introduceti numarul de threadrui: ";
	cin >> stop;

	n = strlen(globaltext) / stop;

	total = ctr = 0;

	start_time = clock();

	std::vector<std::thread*> thread_vector;

	for (int i = 0; i < stop; i++)
	{
		ctr = 0;
		if (i == stop - 1)
		{
			end = strlen(globaltext);
		}
		else
		{
			end = (i + 1)*n;
		}
		start = i * n;

		thread_vector.push_back(new thread(numara, globaltext, start, end, &ctr));

		total += ctr;
	}

	for (int i = 0; i < stop; i++)
	{
		thread_vector[i]->join();
	}

	end_time = clock();

	time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

	cout << endl;

	cout << globaltext << endl << endl << "Textul de mai sus contine: ";

	cout << total << " vocale" << endl;

	cout << "CPU time: " << time_used << " seconds" << endl;

	while (1);
	return 0;

}