package model;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import model.VirtualPageNumber;

public class TranslationLookasideBuffer {
	private HashMap<VirtualPageNumber, PhysicalPageNumber> tlb;
	private int size;
	
	public TranslationLookasideBuffer(int size) {
		this.tlb = new HashMap<VirtualPageNumber, PhysicalPageNumber>(size, 1);
		this.size = size;
	}
	
	public boolean isTlbHit(VirtualPageNumber vpn) {
		return this.tlb.containsKey(vpn);
	}
	
	public boolean isTlbFull() {
		return this.tlb.size() == size;
	}
	
	public PhysicalPageNumber getPhysicalPageNumber(VirtualPageNumber vpn) {
		if(this.isTlbHit(vpn)) {
			return this.tlb.get(vpn);
		}
		
		return null;
	}
	
	public void updateTlb(VirtualPageNumber vpn, PhysicalPageNumber ppn) {
		//if it contains the vpn already the update method is never called
		
		if(this.tlb.size() < this.size){
			this.tlb.put(vpn, ppn);
			System.out.println("Size1: " + this.tlb.size() + " " + this.size);
			
		}else {
			VirtualPageNumber toBeRemoved = this.findMinClock();
			this.tlb.remove(toBeRemoved);
			this.tlb.put(vpn, ppn);
			System.out.println("Size2: " + this.tlb.size() + " " + this.size);
		}
		System.out.println("Size3: " + this.tlb.size() + " " + this.size);
	}
	
	//getting the VPN with the min clock
	private VirtualPageNumber findMinClock() {
		//class cast exception?
		HashSet<VirtualPageNumber> vpnSet = new HashSet(this.tlb.keySet());
		Iterator<VirtualPageNumber> it = vpnSet.iterator();
		VirtualPageNumber currentVpn; 
		VirtualPageNumber minVpn = null;
		int min = Integer.MAX_VALUE;
		
		while(it.hasNext()) {
			currentVpn = it.next();
			if(currentVpn.getClock() < min) {
				min = currentVpn.getClock();
				minVpn = currentVpn;
			}
			
		}
		
		return minVpn;
	}

	public HashMap<VirtualPageNumber, PhysicalPageNumber> getTlb() {
		return tlb;
	}
	
	

}
