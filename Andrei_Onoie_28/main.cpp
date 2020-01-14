#include "pch.h"
#include <iostream>
#include <Windows.h>
#include <Sysinfoapi.h>
#include <time.h>
#include <chrono>  // for high_resolution_clock

/*
	RdTSC:
	It's the Pentium instruction "ReaD Time Stamp Counter". It measures the
	number of clock cycles that have passed since the processor was reset, as a
	64-bit number. That's what the _emit lines do.
*/
#define RdTSC __asm _emit 0x0f __asm _emit 0x31

// https://docs.microsoft.com/en-us/windows/win32/api/sysinfoapi/ns-sysinfoapi-system_info
void printArch()
{
	_SYSTEM_INFO lpSystemInfo;
	GetNativeSystemInfo(&lpSystemInfo);

	switch (lpSystemInfo.wProcessorArchitecture) {
	case PROCESSOR_ARCHITECTURE_AMD64:
		std::cout << "x64 (AMD or Intel) \n";
		break;
	case PROCESSOR_ARCHITECTURE_ARM:
		std::cout << "ARM\n";
		break;
	case PROCESSOR_ARCHITECTURE_ARM64:
		std::cout << "ARM64\n";
		break;
	case PROCESSOR_ARCHITECTURE_IA64:
		std::cout << "Intel Itanium-based\n";
		break;
	case PROCESSOR_ARCHITECTURE_INTEL:
		std::cout << "x86\n";
		break;
	default:
		std::cout << "Unknown architecture\n";
	}

}

// https://www.codeproject.com/Articles/7340/Get-the-Processor-Speed-in-two-simple-ways
float ProcSpeedCalc()
{


	// variables for the clock-cycles:
	__int64 cyclesStart = 0, cyclesStop = 0;
	// variables for the High-Res Preformance Counter:
	unsigned __int64 nCtr = 0, nFreq = 0, nCtrStop = 0;


	// retrieve performance-counter frequency per second:
	if (!QueryPerformanceFrequency((LARGE_INTEGER *)&nFreq)) return 0;

	// retrieve the current value of the performance counter:
	QueryPerformanceCounter((LARGE_INTEGER *)&nCtrStop);

	// add the frequency to the counter-value:
	nCtrStop += nFreq;


	_asm
	{// retrieve the clock-cycles for the start value:
		RdTSC
		mov DWORD PTR cyclesStart, eax
		mov DWORD PTR[cyclesStart + 4], edx
	}

	do {
		// retrieve the value of the performance counter
		// until 1 sec has gone by:
		QueryPerformanceCounter((LARGE_INTEGER *)&nCtr);
	} while (nCtr < nCtrStop);

	_asm
	{// retrieve again the clock-cycles after 1 sec. has gone by:
		RdTSC
		mov DWORD PTR cyclesStop, eax
		mov DWORD PTR[cyclesStop + 4], edx
	}

	// stop-start is speed in Hz divided by 1,000,000 is speed in MHz
	return    ((float)cyclesStop - (float)cyclesStart) / 1000000;
}

float MemCalc()
{
	ULONGLONG mem;

	if (GetPhysicallyInstalledSystemMemory(&mem)) {
		return mem / 1024.0;
	}
	else
	{
		return -1;
	}
}

void testAND() {
	_asm {
		AND eax, eax
	}
}

void testOR() {
	_asm {
		OR eax, eax
	}
}

void testXOR() {
	_asm {
		XOR eax, eax
	}
}

void testADD() {
	_asm {
		ADD eax, eax
	}
}

void testMUL() {
	_asm {
		MUL ecx
	}
}

void prepareDIV() {
	_asm {
		xor edx, edx
		mov eax, 0x8003 // dividend
		mov ebx, 4  // divisor
	}
}
void testDIV() {
	_asm {
		DIV ebx
	}
}


int moveBlock(int blockSize) {
	srand(time(NULL));
	char *oldPtr = (char*) calloc(blockSize, sizeof(char));

	for (int i = 0; i < blockSize; i++)
		oldPtr[i] = rand() % 256;
	
	char *newPtr = (char*)calloc(blockSize, sizeof(char));


	// variables for the clock-cycles:
	__int64 cyclesStart = 0, cyclesStop = 0;

	_asm
	{
		// retrieve the clock-cycles for the start value:
		RdTSC
		mov DWORD PTR cyclesStart, eax
		mov DWORD PTR[cyclesStart + 4], edx
	}

	memmove(newPtr, oldPtr, blockSize);

	_asm
	{// retrieve again the clock-cycles after operations are done
		RdTSC
		mov DWORD PTR cyclesStop, eax
		mov DWORD PTR[cyclesStop + 4], edx
	}

	free(oldPtr);
	free(newPtr);

	return cyclesStop - cyclesStart;

}

double GetNoOfCycles(void (*func)())
{
	// variables for the clock-cycles:
	__int64 cyclesStart = 0, cyclesStop = 0;
	
	prepareDIV();

	_asm
	{
		// retrieve the clock-cycles for the start value:
		RdTSC
		mov DWORD PTR cyclesStart, eax
		mov DWORD PTR[cyclesStart + 4], edx
	}

	func();
	
	_asm
	{// retrieve again the clock-cycles after operations are done
		RdTSC
		mov DWORD PTR cyclesStop, eax
		mov DWORD PTR[cyclesStop + 4], edx
	}

	return (int) (cyclesStop - cyclesStart);

}

void testOperations()
{
	const char *funcNames[] = { "testAND", "testOR", "testXOR", "testADD", "testMUL", "testDIV" };
	void (*funcs[])() = { testAND, testOR, testXOR, testADD, testMUL, testDIV };
	double sum;
	int trials = 1000;

	for (int i = 0; i < 6; i++) {
		sum = 0;
		for (int j = 0; j < trials; j++)
			sum += GetNoOfCycles(funcs[i]);
		std::cout << "Operations " << funcNames[i] << " took " << sum / trials << " cycles on average\n";
	}
}

int main()
{

	std::cout << "Processor architecture: ";
	printArch();
	
	std::cout << "Clock speed: " << ProcSpeedCalc() << " MHz\n";
	std::cout << "Physical memory: " << MemCalc() << "MB\n";
	getchar();
	testOperations();

	std::cout << "Moving a 10k block of memory took ";
	double sum = 0;
	for (int i = 0; i < 100; i++) {
		sum += moveBlock(10 * 1024);
	}
	std::cout << sum / 100 << " cycles.\n";
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
