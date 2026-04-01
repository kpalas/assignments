# Cache Replacement & Paging Simulators

## 🎯 Overview
This project simulates how operating systems and applications manage memory when dealing with limited cache sizes. It includes implementations of several classic cache eviction and paging algorithms to handle request sequences efficiently.

## My Contributions
The testing environment and node classes were provided as university boilerplate. My core work focused on designing and implementing the algorithms within `COMP108Cab.java` and `COMP108Paging.java`:

* **Least Recently Used (LRU):** Implemented an `evictLRU` algorithm that tracks the usage history of pages in an array and replaces the page that has not been used for the longest time.
* **First-In, First-Out (FIFO):** Implemented an `evictFIFO` algorithm using modular arithmetic to replace the oldest page in the cache.
* **Frequency Counting (LFU variation):** Built a `freqCount` algorithm using a custom Doubly Linked List. When a cache miss occurs, new items are added; when a hit occurs, the item's frequency is updated and it is dynamically repositioned in the list based on non-increasing frequency.
* **Miss/Hit Tracking:** Implemented `appendIfMiss` to traverse linked lists, track cache hits/misses, and append missing requests.

## Performance Analysis
A key component of this project was analyzing the time complexity of the implemented algorithms. I have included detailed Big-O analysis and justifications within the comments of my source code, taking into account cache size ($p$) and the number of requests ($n$). 

## 🚀 How to Run
To run the simulations, compile the Java files and execute the respective App classes:
1. `javac *.java`
2. `java COMP108PagingApp` (to test LRU and FIFO)
3. `java COMP108CabApp` (to test Frequency Counting and Append-if-Miss)
