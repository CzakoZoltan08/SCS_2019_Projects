package model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PageTable {
	private HashMap<VirtualPageNumber, PageTableEntry> pageTable;
	private int vpnBits;
	
	public PageTable(int vpnBits) {
		this.pageTable = new HashMap<VirtualPageNumber, PageTableEntry>(this.computeSize(vpnBits), 1);
		this.vpnBits = vpnBits;
	}
	
	public boolean isHit(VirtualPageNumber vpn) {
		if(this.pageTable.containsKey(vpn)) {
			return this.pageTable.get(vpn).isValid();
		}
		
		return false;
	}
	
	public PhysicalPageNumber getPhysicalPageNumber(VirtualPageNumber vpn) {
		return this.pageTable.get(vpn).getPpn();
	}
	
	
	public void addPageTableEntry(VirtualPageNumber vpn, PhysicalPageNumber ppn) {
		//what if I don't have a vpn at that index?
		//I should receive ppn with valid bit already set on the right value
		
		//where do I set valid bit to false?
		//the manager, dummy
		
		PageTableEntry newEntry = new PageTableEntry(ppn);
		
		// contains + valid bit = true -> otherwise the page is not in mem
		if(this.pageTable.containsKey(vpn)) {
			PageTableEntry oldEntry = this.pageTable.get(vpn);
			this.pageTable.replace(vpn, oldEntry, newEntry);
		}else {
			this.pageTable.put(vpn, newEntry);
		}
	}

	public HashMap<VirtualPageNumber, PageTableEntry> getPageTable() {
		return pageTable;
	}
	
	//to review this function
	private int computeSize(int vpnBits) {
		int max = 0;
		for(int i = 0; i < vpnBits - 1; i++) {
			max <<= 1;
			max |= 1;
		}
		
		return max;
	}
	
	//when I move a page from physical mem back to disk I have to update
	//the page table

}
