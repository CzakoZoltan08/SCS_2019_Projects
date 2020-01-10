package com.hhp.multicore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;

public class MultiCoreProcessor {

	//----------------------------------------------
	//-----------------List as input-----------------
	//----------------------------------------------

	public static void callConsumer(List lst, Consumer<Object> c) {
		getListOfSubListsForCores(lst).parallelStream().forEach(subList -> c.accept(subList));
	}

	public static void callUnparallelConsumer(List lst, Consumer<Object> c) {
		getListOfSubListsForCores(lst).stream().forEach(subList -> c.accept(subList));
	}

	private static List<List<Object>> getListOfSubListsForCores(List lst) {
		int noOfCores 		= Runtime.getRuntime().availableProcessors();
		int minBatchSize 	= lst.size()/noOfCores;
		int leftOver 		= lst.size() % noOfCores;
		List<List<Object>> subLists = new ArrayList<>(noOfCores);
		int fromIndex 		= 0;
		int toIndex 		= minBatchSize;
		for (int i = 0; i < noOfCores; i++) {
			if (leftOver > 0) {
				toIndex++;
				leftOver--;
			}
			subLists.add(lst.subList(fromIndex, toIndex));
			fromIndex 	= toIndex;
			toIndex 	+= minBatchSize;
		}
		return subLists;
	}

}