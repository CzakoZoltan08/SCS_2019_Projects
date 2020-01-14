package model;

public class PhysicalPageNumber {
	private int physicalPageNumber;
	private int memSize = 8;
	
	public PhysicalPageNumber(int ppn) {
		this.physicalPageNumber = ppn;
		
	}

	public int getPhysicalPageNumber() {
		return physicalPageNumber;
	}
	
	//??
	@Override
	public int hashCode() {
		return physicalPageNumber % memSize;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PhysicalPageNumber other = (PhysicalPageNumber) obj;
		if (physicalPageNumber != other.getPhysicalPageNumber())
			return false;
		return true;
	}

	
	
	

}
