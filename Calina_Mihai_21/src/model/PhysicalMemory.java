package model;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import manager.Manager;
import manager.Strategy;

public class PhysicalMemory {
	private HashMap<PhysicalPageNumber, PhysicalMemoryPage> physicalMemory;
	private int size;
	private Strategy strategy;
	private int count = 0;
	
	public PhysicalMemory(Strategy s, int ppnBits) {
		this.physicalMemory = new HashMap<PhysicalPageNumber, PhysicalMemoryPage>(this.computeSize(ppnBits), 1);
		this.size = this.computeSize(ppnBits);
		this.strategy = s;
	}
	
	public boolean isFull() {
		if(this.physicalMemory.size() == this.size + 1) {
			return true;
		}else {
			return false;
		}
	}
	
	public int updatePhysicalMemory(VirtualPageNumber vpn) {
		//1. mem not full
		//2. mem full
		//3. address already in mem
		//4. nre address
		
		//1. in mem?
		//1.1 yes, modify dirty bit 
		//1.1.1 LRU -> modify clock
		//1.1.2 FIFO -> don't modify clock
		//1.2 no, add the address in mem -> FIFO -> clock
		
		PhysicalMemoryPage newPmp = new PhysicalMemoryPage(vpn);
		
		//careful with this...verify for -1 where you gonna use it
		int index = -1;
		
		if(this.containsVpn(vpn)) {
			PhysicalMemoryPage pmp = this.getVpnSpeficicPmp(vpn);
			if(this.strategy == Strategy.LRU) {
				pmp.setClock(Manager.clock);
			}
			pmp.setDirtyBit(true);
			System.out.println("I'm here");
			
		}else {
			if(this.isFull()) {
				PhysicalMemoryPage toBeReplaced = this.findMinClock();
				
				HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
				PhysicalMemoryPage pmp = null;
				
				for(PhysicalPageNumber ppn : keySet) {
					pmp = this.physicalMemory.get(ppn);
					if(pmp == toBeReplaced) {
						newPmp.setClock(Manager.clock);
						this.physicalMemory.replace(ppn, toBeReplaced, newPmp);
						index = ppn.getPhysicalPageNumber();
					}
				}
				
				return index;
			}else {
				newPmp.setClock(Manager.clock);
				this.physicalMemory.put(new PhysicalPageNumber(count), newPmp);
				this.count++;
				
				return this.count - 1;
			}
		}
		
		return index;
	}

	public boolean containsVpn(VirtualPageNumber vpn) {
		HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
		PhysicalMemoryPage pmp;
		
		for(PhysicalPageNumber ppn : keySet) {
			pmp = this.physicalMemory.get(ppn);
			
			if(pmp.getVirtualPageNumber().equals(vpn)) {
				return true;
			}
		}
		
		return false;
	}
	
	private PhysicalMemoryPage getVpnSpeficicPmp(VirtualPageNumber vpn) {
		HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
		PhysicalMemoryPage pmp = null;
		
		for(PhysicalPageNumber ppn : keySet) {
			pmp = this.physicalMemory.get(ppn);
			
			if(pmp.getVirtualPageNumber().equals(vpn)) {
				return pmp;
			}
		}
		
		return null;
	}
	
	public PhysicalPageNumber getVpnSpecificPpn(VirtualPageNumber vpn) {
		HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
		PhysicalMemoryPage pmp = null;
		
		for(PhysicalPageNumber ppn : keySet) {
			pmp = this.physicalMemory.get(ppn);
			
			if(pmp.getVirtualPageNumber().equals(vpn)) {
				return ppn;
			}
		}
		
		return null;
	}
	
	public PhysicalMemoryPage findMinClock() {
		int min = Integer.MAX_VALUE;
		PhysicalMemoryPage minPmp = null;
		HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
		PhysicalMemoryPage currMemPage, minMemPage = null;
		int minClock = Integer.MAX_VALUE;
		
		for(PhysicalPageNumber ppn : keySet) {
			currMemPage = this.physicalMemory.get(ppn);
			
			if(currMemPage.getClock() < minClock) {
				minClock = currMemPage.getClock();
				minMemPage = currMemPage;
			}
		}
		
		return minMemPage;
	}
	
	private int computeSize(int ppnBits) {
		int max = 1;
		for(int i = 0; i < ppnBits - 1; i++) {
			max <<= 1;
			max |= 1;
		}
		System.out.println("Max: " + max);
		return max;
	}

	public HashMap<PhysicalPageNumber, PhysicalMemoryPage> getPhysicalMemory() {
		return physicalMemory;
	}
	
	//to be used only after verifying that pmp exists in mem
	public boolean getDirtyBitStatus(PhysicalMemoryPage pmp) {
		HashSet<PhysicalPageNumber> keySet = new HashSet(this.physicalMemory.keySet());
		PhysicalMemoryPage currentPmp;
		
		for(PhysicalPageNumber ppn : keySet) {
			currentPmp = this.physicalMemory.get(ppn);
			
			if(currentPmp.equals(pmp)) {
				return currentPmp.isDirtyBit();
			}
		}
		
		return false;
	}

}
