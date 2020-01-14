package model;

import manager.Manager;

public class VirtualPageNumber {
	private int pageNumber;
	private int clock;
	
	public VirtualPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
		//should we instantiate with the current clock?
		this.clock = Manager.clock;
	}

	public int getPageNumber() {
		return pageNumber;
	}

	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}

	public int getClock() {
		return clock;
	}

	public void setClock(int clock) {
		this.clock = clock;
	}

	//TODO: generate unique values
	//vpn are uniquee for page table 
	//not unique for tlb
	@Override
	public int hashCode() {
		return this.pageNumber;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		VirtualPageNumber other = (VirtualPageNumber) obj;
		if (pageNumber != other.getPageNumber())
			return false;
		return true;
	}
	
	
}
