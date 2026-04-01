//
// Coded by Prudence Wong 2021-03-06
// Updated 2023-02-25
// Do not change this file
// Changes in this file will NOT be graded
//
class COMP108Node {
	public int data; 
	public COMP108Node next;
	public COMP108Node prev;
	public int freq; // only to be used in freqCount algorithm
    
	// constructor to create a new node with data equals to parameter i
	public COMP108Node (int i) {
		next = null;
		prev = null;
		data = i;
		freq = 1;
	}
}
