package model;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class Semaphore {
    private int id;
    private int state;
   // ArrayList<Phase> phases = new ArrayList<Phase>();
    //0 for state means red, 1 means green
    public Semaphore(int id)
    {
        this.id=id;
        this.state=0;
    }
    public void setGreen()
    {
        this.state=1;
    }
    public void setRed()
    {
        this.state=0;
    }
}
