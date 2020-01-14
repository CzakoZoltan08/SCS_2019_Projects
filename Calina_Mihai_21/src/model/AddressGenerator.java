package model;

import java.util.Random;

public class AddressGenerator {
	
	//singleton pattern
	private int noBits;
	private int offsetBits;
	private int pageNumberBits;
	private static Random rand = new Random();
	private static AddressGenerator addrGen;
	
	private AddressGenerator(int pageNumberBits, int offsetBits) {
		this.pageNumberBits = pageNumberBits;
		this.offsetBits = offsetBits;
		this.noBits = pageNumberBits + offsetBits;
	}
	
	public int generateAddress() {
		int generatedValue, maxValue;
		maxValue = compMaxValue();
		//specified value for nextInt exclusive
		generatedValue = rand.nextInt(maxValue + 1);
		
		return generatedValue;
	}
	
	private int compMaxValue() {
		int max = 1;
		
		for(int i = 0; i < noBits - 1; i++) {
			max <<= 1;
			max |= 0x00000001;
		}
		
		return max;
	}
	
	public static AddressGenerator getInstance(int pageNumberBits, int offsetBits) {
		if(addrGen == null) {
			addrGen = new AddressGenerator(pageNumberBits, offsetBits);
		}
		
		return addrGen;
	}
	
	public int getAddrMaxVal() {
		return this.compMaxValue();
	}

}
