#include <iostream>
#include <ctime>
#include <cstdlib>
#include <vector>

using namespace std;

vector<int> generateNumbers(int count)
{
	vector<int> numbers;
	for (int i = 1; i <= count; i++)
		numbers.push_back(i);
	return numbers;
}

vector<int> pickRandom(int pickCount, vector<int> numbers)
{
	vector<int> pickedNumbers;
	for (int i = 0; i < pickCount; i++)
	{
		int randomIndex = rand() % numbers.size();
		pickedNumbers.push_back(numbers[randomIndex]);
		numbers.erase(numbers.begin() + randomIndex);
	}
	return pickedNumbers;
}

vector<int> pickRandomFisherYates(int pickCount, vector<int> numbers)
{
	int n = numbers.size();
	for (int i = n - 1; i > 0; i--)
	{
		int j = rand() % (i + 1);
		swap(numbers[i], numbers[j]);
	}
	return vector<int>(numbers.begin(), numbers.begin() + pickCount);
}

void benchmark()
{
	const int iterations = 1000;
	const int totalNumbers = 10000;
	const int pickCount = 5000;

	auto start = chrono::high_resolution_clock::now();
	for (int i = 0; i < iterations; i++)
	{
		vector<int> numbers = generateNumbers(totalNumbers);
		pickRandom(pickCount, numbers);
	}
	auto end = chrono::high_resolution_clock::now();
	auto duration1 = chrono::duration_cast<chrono::nanoseconds>(end - start);

	start = chrono::high_resolution_clock::now();
	for (int i = 0; i < iterations; i++)
	{
		vector<int> numbers = generateNumbers(totalNumbers);
		pickRandomFisherYates(pickCount, numbers);
	}
	end = chrono::high_resolution_clock::now();
	auto duration2 = chrono::duration_cast<chrono::nanoseconds>(end - start);

	cout << "Parameters: totalNumbers = " << totalNumbers << ", pickCount = " << pickCount << "\n";
	cout << "\n--- Benchmark Results (" << iterations << " iterations) ---\n";
	cout << "pickRandom: " << duration1.count() << "ns\n";
	cout << "pickRandomFisherYates: " << duration2.count() << "ns\n";
	cout << "Speedup: " << (double)duration1.count() / duration2.count() << "x\n";
}

int main()
{
	srand(time(0));
	benchmark();
}
