package model;

import manager.Manager;

public class PhysicalMemoryPage {
	private VirtualPageNumber vpn;
	private boolean dirtyBit;
	private int clock;
	//we need this since this clock is specific to PM and the vpn clock is specific
	//to the TLB
	
	public PhysicalMemoryPage(VirtualPageNumber vpn) {
		this.vpn= vpn;
		this.dirtyBit = false;
		this.clock = Manager.clock;
	}

	public boolean isDirtyBit() {
		return dirtyBit;
	}

	public void setDirtyBit(boolean dirtyBit) {
		this.dirtyBit = dirtyBit;
	}

	public int getClock() {
		return clock;
	}

	public void setClock(int clock) {
		this.clock = clock;
	}

	public VirtualPageNumber getVirtualPageNumber() {
		return vpn;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PhysicalMemoryPage other = (PhysicalMemoryPage) obj;

		if(other.getVirtualPageNumber().getPageNumber() != this.getVirtualPageNumber().getPageNumber()) {
			return false;
		}
		return true;
	}
	
	
}
