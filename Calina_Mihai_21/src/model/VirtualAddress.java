package model;

public class VirtualAddress {
	private int virtualPageNumber;
	private int offset;
	private int pageNumberBits;
	private int offsetBits;
	private int address;
	
	public VirtualAddress(int address, int pageNumberBits, int offsetBits) {
		this.address = address;
		this.pageNumberBits = pageNumberBits;
		this.offsetBits = offsetBits;
	}
	
	private int extractOffset() {
		int mask = 1;
		
		for(int i = 0; i < this.offsetBits - 1; i++) {
			mask <<= 1;
			mask |= 1;
		}
		
		return this.address & mask;
		
	}
	
	private int extractVirtualPageNumber() {
		//mask is on 32 bits, address is on 7 (in my ex)
		int mask = 1;
		int temp;
		
		for(int i = 0; i < this.pageNumberBits - 1; i++) {
			mask <<= 1;
			mask |= 1;
			
		}
		
		for(int i = 0; i < this.offsetBits; i++) {
			mask <<= 1;
		}
		
		temp = this.address & mask;
		
		for(int i = 0; i < this.offsetBits; i++) {
			temp >>= 1;
		}
		
		return temp;
	}

	public VirtualPageNumber getVirtualPageNumber() {
		//a bit of useless work done here
		//TODO: come up with a better idea
		this.virtualPageNumber = this.extractVirtualPageNumber();
		VirtualPageNumber vpn = new VirtualPageNumber(this.virtualPageNumber);
		
		return vpn;
	}

	public int getOffset() {
		this.offset = this.extractOffset();
		return this.offset;
	}

}
