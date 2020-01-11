package com.hhp.multicore;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.junit.Test;

import com.hhp.multicore.MultiCoreProcessor;
import com.hhp.multicore.info.CoreInfo;

public class SingleCore_Consumer_AnonymousClassTest {

    static Map<String, CoreInfo> m = new HashMap<String, CoreInfo>();

    static Integer count = 0;

    @Test public void test() {
        List<Integer> lst = new ArrayList<Integer>();
        for (int i = 0; i < 1102; i++) {
            lst.add(i);
        }
        //-----------------
        MultiCoreProcessor.callUnparallelConsumer(lst, new Consumer<Object>() {//pass list & function to multi core processor..
            @Override
            public void accept(Object o) {
                List<Integer> lst = (List<Integer>) o;
                int sum = 0;
                for (Integer i : lst) {
                    sum += i;
                }
                synchronized (count) {
                    count += sum;
                }
                //-----------------
                Date s = new Date();
                for (int j = 0; j < 100000000; j++) {
                    Math.tan(j);//some operation that takes long time
                }
                String core = Thread.currentThread().getName();
                Date e = new Date();
                synchronized (m) {
                    CoreInfo coreInfo = m.get(core);
                    if (coreInfo == null) {
                        coreInfo = new CoreInfo();
                        coreInfo.name 		= core;
                        coreInfo.startTime 	= s;
                        coreInfo.endTime 	= e;
                        coreInfo.numberOfRecords += lst.size();
                    } else {
                        coreInfo.startTime = (coreInfo.startTime.before(s)) ? coreInfo.startTime : s;
                        coreInfo.endTime = (coreInfo.endTime.after(e)) ? coreInfo.endTime : e;
                        coreInfo.numberOfRecords += lst.size();
                    }
                    m.put(core, coreInfo);
                }
            }
        });
        //-----------------
        System.out.println(count);
        //-----------------
        printCoreInfo();
    }

    private static void printCoreInfo() {
        StringBuilder performanceMsg = new StringBuilder();
        for (String core : m.keySet()) {
            performanceMsg = performanceMsg.append(m.get(core).toString());
        }
        System.out.println(performanceMsg.toString());
    }
}