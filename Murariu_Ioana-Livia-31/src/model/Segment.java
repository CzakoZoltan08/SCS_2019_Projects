package model;

public class Segment {
	private int beginX, endX, beginY, endY;
	private String segType;

	public Segment(String segType, int beginX, int endX, int beginY, int endY) {
		super();
		this.beginX = beginX;
		this.endX = endX;
		this.beginY = beginY;
		this.endY = endY;
		this.segType = segType;
	}

	public int getBeginX() {
		return beginX;
	}

	public void setBeginX(int beginX) {
		this.beginX = beginX;
	}

	public int getEndX() {
		return endX;
	}

	public void setEndX(int endX) {
		this.endX = endX;
	}

	public int getBeginY() {
		return beginY;
	}

	public void setBeginY(int beginY) {
		this.beginY = beginY;
	}

	public int getEndY() {
		return endY;
	}

	public void setEndY(int endY) {
		this.endY = endY;
	}

	public String getSegType() {
		return segType;
	}

	public void setSegType(String segType) {
		this.segType = segType;
	}

}
