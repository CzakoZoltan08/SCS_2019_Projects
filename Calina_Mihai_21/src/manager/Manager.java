package manager;

import java.util.ArrayList;
import java.util.HashSet;

import model.AddressGenerator;
import model.PageTable;
import model.PageTableEntry;
import model.PhysicalMemory;
import model.PhysicalMemoryPage;
import model.PhysicalPageNumber;
import model.TranslationLookasideBuffer;
import model.VirtualAddress;
import model.VirtualPageNumber;

public class Manager {
	public static int clock = 0;
	private int virtualPageNumberBits;
	private int physicalPageNumberBits;
	private int offsetBits;
	private int tlbSize;
	private AddressGenerator addrGen;
	private TranslationLookasideBuffer tlb;
	private PageTable pageTable;
	private PhysicalMemory physicalMemory;
	
	
	private VirtualAddress currentAddr;
	
	public Manager(Strategy s, int vpnBits, int ppnBits, int offsetBits, int tlbSize) {
		this.addrGen = AddressGenerator.getInstance(vpnBits, offsetBits);
		this.tlb = new TranslationLookasideBuffer(tlbSize);
		
		this.virtualPageNumberBits = vpnBits;
		this.physicalPageNumberBits = ppnBits;
		this.offsetBits = offsetBits;
		this.tlbSize = tlbSize;
		
		this.pageTable = new PageTable(this.virtualPageNumberBits);
		this.physicalMemory = new PhysicalMemory(s, ppnBits);
	}
	
	public VirtualAddress createAddress(int address) {
		this.currentAddr = new VirtualAddress(address, this.virtualPageNumberBits, this.offsetBits);
		return this.currentAddr;
	}
	
	public int generateAddress() {
		return this.addrGen.generateAddress();
	}
	
	public boolean tlbSearch(VirtualAddress va) {
		return this.tlb.isTlbHit(va.getVirtualPageNumber());
	}
	
	public boolean pageTableSearch(VirtualAddress va) {
		return this.pageTable.isHit(va.getVirtualPageNumber());
	}
	
	public int pageTableHit(VirtualAddress va) {
		return this.pageTable.getPhysicalPageNumber(va.getVirtualPageNumber()).getPhysicalPageNumber();
	}
	
	public int updatePhysicalMem(VirtualAddress va) {
		int physicalMemIndex;
		
		physicalMemIndex = this.physicalMemory.updatePhysicalMemory(va.getVirtualPageNumber());
		
		return physicalMemIndex;
	}
	
	public boolean isMemFull() {
		return this.physicalMemory.isFull();
	}
	
	public void updatePageTable(VirtualAddress va) {
		this.pageTable.addPageTableEntry(va.getVirtualPageNumber(), this.physicalMemory.getVpnSpecificPpn(va.getVirtualPageNumber()));
		this.verify();
	}
	
	public void updateTlb(VirtualAddress va) {
		this.verifyTlb();
		this.tlb.updateTlb(va.getVirtualPageNumber(), this.physicalMemory.getVpnSpecificPpn(va.getVirtualPageNumber()));
	}
	
	//what am I using this for?
	public int getMaxAddrVal() {
		return this.addrGen.getAddrMaxVal();
	}

	public TranslationLookasideBuffer getTlb() {
		return tlb;
	}

	public PageTable getPageTable() {
		return pageTable;
	}

	public PhysicalMemory getPhysicalMemory() {
		return physicalMemory;
	}
	
	public boolean getDirtyBitStatus() {
		PhysicalMemoryPage pmp = this.physicalMemory.findMinClock();
		return pmp.isDirtyBit();
	}
	
	public void verify() {
		HashSet<VirtualPageNumber> keySet = new HashSet(this.pageTable.getPageTable().keySet());
		PageTableEntry pte;
		
		for(VirtualPageNumber vpn : keySet) {
			pte = this.pageTable.getPageTable().get(vpn);
			
			if(this.physicalMemory.containsVpn(vpn)) {
				if(!pte.getPpn().equals(this.physicalMemory.getVpnSpecificPpn(vpn))) {
					pte.setValid(false);
					//this.updatePageTable(currentAddr);
				}
			}else {
				pte.setValid(false);
				//this.updatePageTable(currentAddr);
			}
		}
	}
	
	public void verifyTlb() {
		HashSet<VirtualPageNumber> keySet = new HashSet(this.tlb.getTlb().keySet());
		ArrayList<VirtualPageNumber> toBeRemoved = new ArrayList<VirtualPageNumber>();
		
		for(VirtualPageNumber vpn : keySet) {
			if(!this.pageTable.isHit(vpn)) {
				toBeRemoved.add(vpn);
			}
		}
		
		for(VirtualPageNumber vpn : toBeRemoved) {
			this.tlb.getTlb().remove(vpn);
		}
	}

}
