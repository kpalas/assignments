//
// Coded by Prudence Wong 2021-12-29
// Updated 2023-02-26
// Updated 2024-03-03
// Updated 2025-01-23
// Updated 2025-03-04
//
import java.util.*;
import java.io.*;

class COMP108PagingApp {

	private static final int MAX_CACHE_SIZE = 10;
	private static final int MAX_REQUEST_SIZE = 100;
	private static final int AllAlg = 0;
	private static final int EvictFIFO = 1;
	private static final int EvictLRU = 3;
	private static final int AllOutput = 0;
	private static final int HitMissCount = 2;
	private static final int HitMissPattern = 3;
	private static final int CacheContent = 4;

	private static Scanner keyboardInput = new Scanner (System.in);


	// Do NOT change the main method!
	// main program
	public static void main(String[] args) throws Exception {
		int requestSize=0, cacheSize=0;
		int[] orgCache = new int[MAX_CACHE_SIZE];
		int[] cache = new int[MAX_CACHE_SIZE];
		int[] request = new int[MAX_REQUEST_SIZE];
		COMP108PagingOutput output = new COMP108PagingOutput();
		
		initArray(orgCache, MAX_CACHE_SIZE, -1);
		initArray(request, MAX_REQUEST_SIZE, 0);

		int algorithmChoice = AllAlg;
		int outputChoice = AllOutput;

		// get option of algorithms to run and output to display
		try {
			algorithmChoice = AllAlg;
			outputChoice = AllOutput;
			if (args.length > 0) {
				algorithmChoice = Integer.parseInt(args[0]);
				if (args.length > 1) {
					outputChoice = Integer.parseInt(args[1]);
				}
			}
			
		}
		catch (Exception e) {
			System.err.println("Command-line argument: algorithm choice; output choice"); 
			System.exit(0);
		}
		
		// get the cache size and the number of requests 
		// then get the corresponding input in the respective arrays
		try {
			if (algorithmChoice == AllAlg) {
				System.out.println();
				System.out.print("Enter the cache size (1-" + MAX_CACHE_SIZE + "): ");
			}
			cacheSize = keyboardInput.nextInt();
			if (algorithmChoice == AllAlg) {
				System.out.print("Enter the content of the cache (" + cacheSize + " different +ve integers): ");
			}
			for (int i=0; i<cacheSize; i++) {
				orgCache[i] = keyboardInput.nextInt();
			}
			if (algorithmChoice == AllAlg) {
				System.out.println();
				System.out.print("Enter the number of page requests: (1-" + MAX_REQUEST_SIZE + "): ");
			}
			requestSize = keyboardInput.nextInt();
			if (requestSize > MAX_REQUEST_SIZE || requestSize <= 0) {
				System.exit(0);
			}
			if (algorithmChoice == AllAlg) {
				System.out.print("Enter " + requestSize + " +ve integers: ");
			}
			for (int i=0; i<requestSize; i++) {
				request[i] = keyboardInput.nextInt();				
			}
		}
		catch (Exception e) {
			keyboardInput.next();
			System.exit(0);
		}

		if (algorithmChoice == AllAlg) {
			System.out.println();
			System.out.println("Cache content: ");
			printArray(orgCache, cacheSize);
			System.out.println("Request sequence: ");
			printArray(request, requestSize);
		}
		

		if (algorithmChoice == AllAlg || algorithmChoice == EvictFIFO) {
			try {
				System.out.println();
				System.out.println("evictFIFO");
				copyArray(orgCache, cache, cacheSize);
				output = COMP108Paging.evictFIFO(cache, cacheSize, request, requestSize);
				output.print(outputChoice);
			}
			catch (Exception e) {
				errTraceMsg(e, "evictFIFO");
			}
		}

		if (algorithmChoice == AllAlg || algorithmChoice == EvictLRU) {

			try {
				System.out.println();
				System.out.println("evictLRU");
				copyArray(orgCache, cache, cacheSize);
				output = COMP108Paging.evictLRU(cache, cacheSize, request, requestSize);
				output.print(outputChoice);
			}
			catch (Exception e) {
				errTraceMsg(e, "evictLRU");
			}
		}

	}
	
	static void errTraceMsg(Exception e, String errString) {
			System.err.println("Exception: " + errString);
			e.printStackTrace();
	}
	
	
	// Do NOT change this method!
	// set array[0]..array[size-1] to value
	static void initArray(int[] array, int size, int value) {
		for (int i=0; i<size; i++) 
			array[i] = value;
	}
	
	// Do NOT change this method!
	// print array[0]..array[size-1]
	static void printArray(int[] array, int size) {
		for (int i=0; i<size; i++) {
			System.out.print(array[i] + " ");
			if (i%10 == 9)
				System.out.println();
		}
		System.out.println();
	}
	
	// Do NOT change this method!
	// copy numbers from array a1 to array a2, starting from a1[0] to a2[0], up to a1[size-1] to a2[size-1]
	static void copyArray(int[] array1, int[] array2, int size) {
		for (int i=0; i<size; i++) {
			array2[i] = array1[i];
		}
	}	
}
