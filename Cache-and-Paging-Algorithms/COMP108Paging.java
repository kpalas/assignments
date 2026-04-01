//
// Coded by Prudence Wong 2021-12-29
// Updated 2023-02-26
// Updated 2023-03-03
//
// NOTE: You are allowed to add additional methods if you need.
//
// Name: Kian Palas
// Student ID:201828270
//
// Time Complexity and explanation: You can use the following variables for easier reference.
// n denotes the number of requests, p denotes the size of the cache
// n and p can be different and there is no assumption which one is larger
//
// evictFIFO(): Time Complexity O(n * p)
// Justification: Method iterates over each n requests in rArray, for each requests it performs a search through cache array which has size p with the worst case examining all p elements
// evictLRU(): O(n*p)
// Justification: processes each of n requests in rArray , for each request it searches through cache array (p) in worst case examines all p elements. Additionally updates recentUsed array which scans up to another p elements. Remains O(n * p) as this is the highest order , operations involve linear searches relative to p which are performed n times.

class COMP108Paging {


	// evictFIFO
	// Aim: 
	// if a request is not in cache, evict the page present in cache for longest time
	// count number of hit and number of miss, and find the hit-miss pattern; return an object COMP108PagingOutput
	// Input:
	// cArray is an array containing the cache with cSize entries
	// rArray is an array containing the requeset sequence with rSize entries
	static COMP108PagingOutput evictFIFO(int[] cArray, int cSize, int[] rArray, int rSize) {
		COMP108PagingOutput output = new COMP108PagingOutput();
		int pointer = 0;

		for (int i = 0; i < rSize; i++) {
			boolean found = false;
			
			for (int j = 0; j < cSize; j++) {
				if (rArray[i] == cArray[j]) {
					output.hitCount++;
					output.hitPattern+= "h";
					found= true;
					break;
				}

			}
			if (!found) {
				output.missCount++;
				output.hitPattern+="m";
				cArray[pointer % cSize] = rArray[i];
				pointer++;
			}

		}
		output.cache = arrayToString(cArray, cSize);
		return output;
	}

	// evict LRU
	// Aim:
	// if a request is not in cache, evict the page that hasn't been used for the longest amount of time
	// count number of hit and number of miss, and find the hit-miss pattern; return an object COMP108PagingOutput
	// Input:
	// cArray is an array containing the cache with cSize entries
	// rArray is an array containing the requeset sequence with rSize entries
	static COMP108PagingOutput evictLRU(int[] cArray, int cSize, int[] rArray, int rSize) {
		COMP108PagingOutput output = new COMP108PagingOutput();
		int[] recentUsed = new int[cSize];

		for (int i = 0; i <cSize; i++) {
			recentUsed[i] = i - cSize;
		}

		for (int i = 0; i < rSize; i++) {
			int request = rArray[i];
			boolean found = false;
	
			
			for (int j = 0; j < cSize; j++) {
				if (cArray[j] == request) {
					output.hitCount++;
					output.hitPattern += "h";
					recentUsed[j] = i; 
					found = true;
					break;
				}
			}
	
			if (!found) {
				output.missCount++;
				output.hitPattern += "m";
				int pointer = 0;
				for (int j = 1; j < cSize; j++) {
					if (recentUsed[j] < recentUsed[pointer]) {
						pointer = j;
					}
				}
				cArray[pointer] = request;
				recentUsed[pointer] = i; 
			}
		}

		
		output.cache = arrayToString(cArray, cSize);
		return output;
	}

	// DO NOT change this method
	// this will turn the cache into a String
	// Only to be used for output, do not use it to manipulate the cache
	static String arrayToString(int[] array, int size) {
		String outString="";
		
		for (int i=0; i<size; i++) {
			outString += array[i];
			outString += ",";
		}
		return outString;
	}

}

