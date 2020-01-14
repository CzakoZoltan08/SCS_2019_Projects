package model;

public class PageTableEntry {
	private PhysicalPageNumber ppn;
	private boolean valid;
	
	public PageTableEntry(PhysicalPageNumber ppn) {
		this.ppn = ppn;
		this.valid = true;
	}

	public PhysicalPageNumber getPpn() {
		return ppn;
	}

	public void setPpn(PhysicalPageNumber ppn) {
		this.ppn = ppn;
	}

	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}


	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PageTableEntry other = (PageTableEntry) obj;
		if (ppn == null) {
			if (other.ppn != null)
				return false;
		} else if (ppn.getPhysicalPageNumber() != other.ppn.getPhysicalPageNumber())
			return false;
		return true;
	}
	
	

}
