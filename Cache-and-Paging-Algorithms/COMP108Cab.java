//
// Coded by Prudence Wong 2021-03-06
// Updated 2023-02-25
//
// Note: You are allowed to add additional methods if you need.
// Name: Kian Palas
// Student ID: 201828270
//
// Time Complexity and explanation: 
// f denotes initial cabinet size
// n denotes the total number of requests 
// d denotes number of distinct requests
// You can use any of the above notations or define additional notation as you wish.
// 
// appendIfMiss(): O(n x d) 
// 	Justification: All n requests are misses , each of these misses adds a new file to the cabinet , size grows to f + n . Each requests we traverse the list (d) to check for existence (n x d)
// freqCount():	O(n x d) Each request we traverse list for a hit O(d) ,once hit node is reinserted into correct position , totalling for n requests is O(n x d) 
// 

class COMP108Cab {

	public COMP108Node head, tail;
	
	public COMP108Cab() {
		head = null;
		tail = null;
	}

	// append to end of list when miss
	public COMP108CabOutput appendIfMiss(int rArray[], int rSize) {
		COMP108CabOutput output = new COMP108CabOutput(rSize);
		for (int i = 0; i < rSize; i++) {
			int request = rArray[i];
			boolean found = false;
			int comparisons = 0;
			COMP108Node curr = head;
			while (curr != null) {
				comparisons++;
				if (curr.data == request) {
					found = true;
					output.hitCount++;
					output.compare[i] = comparisons;
					break;
				}
				curr = curr.next;
			}
			if (!found) {
				output.missCount++;
				output.compare[i] = comparisons; 
				COMP108Node newNode = new COMP108Node(request);
				insertTail(newNode);
			}
		}
	
		output.cabFromHead = headToTail();
		output.cabFromTail = tailToHead();
		return output;
	}

	// move the file requested so that order is by non-increasing frequency
	public COMP108CabOutput freqCount(int rArray[], int rSize) {
		COMP108CabOutput output = new COMP108CabOutput(rSize);
	
		for (int i = 0; i < rSize; i++) {
			int request = rArray[i];
			boolean found = false;
			int comparisons = 0;
			COMP108Node current = head;
	
			while (current != null) {
				comparisons++;
				if (current.data == request) {
					found = true;
					break;
				}
				current = current.next;
			}
	
			output.compare[i] = comparisons;
	
			if (found) {
				output.hitCount++;
				current.freq++;
	
				if (current.prev != null) current.prev.next = current.next;
				else head = current.next;
	
				if (current.next != null) current.next.prev = current.prev;
				else tail = current.prev;
	
				COMP108Node temp = head;
				COMP108Node prev = null;
	
				while (temp != null && (temp.freq > current.freq || (temp.freq == current.freq && temp != current))) {
					prev = temp;
					temp = temp.next;
				}
	
				if (prev == null) {
					current.next = head;
					if (head != null) head.prev = current;
					head = current;
				} else {
					current.next = prev.next;
					if (prev.next != null) prev.next.prev = current;
					prev.next = current;
					current.prev = prev;
				}
	
				if (current.next == null) tail = current;
	
			} else {
				output.missCount++;
				COMP108Node newNode = new COMP108Node(request);
				newNode.freq = 1;
	
				COMP108Node temp = head;
				COMP108Node prev = null;
	
				while (temp != null && temp.freq >= newNode.freq) {
					prev = temp;
					temp = temp.next;
				}
	
				if (prev == null) {
					newNode.next = head;
					if (head != null) head.prev = newNode;
					head = newNode;
				} else {
					newNode.next = prev.next;
					if (prev.next != null) prev.next.prev = newNode;
					prev.next = newNode;
					newNode.prev = prev;
				}
	
				if (newNode.next == null) tail = newNode;
			}
		}
	
		output.cabFromHead = headToTail();
		output.cabFromTail = tailToHead();
		output.cabFromHeadFreq = headToTailFreq();
		return output;
	}
	


	// DO NOT change this method
	// insert newNode to head of list
	public void insertHead(COMP108Node newNode) {		

		newNode.next = head;
		newNode.prev = null;
		if (head == null)
			tail = newNode;
		else
			head.prev = newNode;
		head = newNode;
	}

	// DO NOT change this method
	// insert newNode to tail of list
	public void insertTail(COMP108Node newNode) {

		newNode.next = null;
		newNode.prev = tail;
		if (tail != null)
			tail.next = newNode;
		else head = newNode;
		tail = newNode;
	}

	// DO NOT change this method
	// delete the node at the head of the linked list
	public COMP108Node deleteHead() {
		COMP108Node curr;

		curr = head;
		if (curr != null) {
			head = head.next;
			if (head == null)
				tail = null;
			else
				head.prev = null;
		}
		return curr;
	}
	
	// DO NOT change this method
	// empty the cabinet by repeatedly removing head from the list
	public void emptyCab() {
		while (head != null)
			deleteHead();
	}


	// DO NOT change this method
	// this will turn the list into a String from head to tail
	// Only to be used for output, do not use it to manipulate the list
	public String headToTail() {
		COMP108Node curr;
		String outString="";
		
		curr = head;
		while (curr != null) {
			outString += curr.data;
			outString += ",";
			curr = curr.next;
		}
		return outString;
	}

	// DO NOT change this method
	// this will turn the list into a String from tail to head
	// Only to be used for output, do not use it to manipulate the list
	public String tailToHead() {
		COMP108Node curr;
		String outString="";
		
		curr = tail;
		while (curr != null) {
			outString += curr.data;
			outString += ",";
			curr = curr.prev;
		}
		return outString;
	}

	// DO NOT change this method
	// this will turn the frequency of the list nodes into a String from head to tail
	// Only to be used for output, do not use it to manipulate the list
	public String headToTailFreq() {
		COMP108Node curr;
		String outString="";
		
		curr = head;
		while (curr != null) {
			outString += curr.freq;
			outString += ",";
			curr = curr.next;
		}
		return outString;
	}

}
