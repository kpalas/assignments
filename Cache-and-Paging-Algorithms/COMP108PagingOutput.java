//
// Coded by Prudence Wong 2021-12-30
// Updated 2023-02-25
// Do not change this file
// Changes in this file will NOT be graded
//
// A class to store output
class COMP108PagingOutput {
	private static final int AllOutput = 0;
	private static final int HitMissCount = 2;
	private static final int HitMissPattern = 3;
	private static final int CacheContent = 4;

	public int hitCount;
	public int missCount;
	public String hitPattern;
	public String cache;
	
	public COMP108PagingOutput() {
		hitCount = 0;
		missCount = 0;
		hitPattern = "";
		cache = "";
	}

	public void print(int item) {
		if (item == AllOutput || item == HitMissPattern) {
			System.out.println(hitPattern);
		}
		if (item == AllOutput || item == HitMissCount) {
			System.out.println(hitCount + " h " + missCount + " m");
		}
		if (item == AllOutput || item == CacheContent) {
			System.out.println("Cache: " + cache);
		}
	}	
}
