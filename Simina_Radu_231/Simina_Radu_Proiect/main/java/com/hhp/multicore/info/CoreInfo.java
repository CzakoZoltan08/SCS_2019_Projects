package com.hhp.multicore.info;

import java.util.Date;

public class CoreInfo {
	public String name 			= null;
	public Date startTime 		= null;
	public Date endTime 		= null;
	public int numberOfRecords 	= 0;

	@Override
	public String toString() {
		StringBuilder performanceMsg = new StringBuilder();
		performanceMsg = performanceMsg.append("name of core     : ").append(name).append("\n")
				.append("started at       : ").append(startTime).append("\n").append("finished at      : ")
				.append(endTime).append("\n").append("number of records: ").append(numberOfRecords)
				.append("\n----------------------------\n");
		return performanceMsg.toString();
	}
}