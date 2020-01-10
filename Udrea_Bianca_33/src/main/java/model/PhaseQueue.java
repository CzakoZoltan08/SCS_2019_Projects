package model;
import java.sql.Time;
import java.util.*;

public class PhaseQueue extends Thread {
    private Comparator<Phase> comparator = new PhaseComparator();
   // PriorityQueue<Phase> phaseQueue = new PriorityQueue<>(12,comparator);
    ArrayList <Phase> phaseQueue=new ArrayList<>();
    private int id;
    private String emptyEvents="";

    private boolean running=true;
    private ArrayList<Integer> emptyQueueTime=new ArrayList<>();
    private ArrayList<Integer>completelyEmptyQueueTime=new ArrayList<>();
    private int SumCompletelyEmptyQueueTime=0;

    public Phase getFirstElement() {

        return phaseQueue.get(0);
    }
    public String getEmptyEvents() {
        return emptyEvents;
    }
    public void sort()
    {
        phaseQueue.sort(comparator);
    }

    public boolean decreaseNoOfCarsFromSem1()
    {
        for(Phase phaseAux:phaseQueue)
        {
            if(phaseAux.getId()==1 || phaseAux.getId()==2 || phaseAux.getId()==3) {
                phaseAux.decreaseNoOfCars();
                if (phaseAux.getNoOfCars() == 0)
                    phaseQueue.remove(phaseAux);
            return true;
            }
        }
        return false;
    }
    public int getSize()
    {
        return phaseQueue.size();
    }
    public boolean decreaseNoOfCarsFromSem3()
    {
        for(Phase phaseAux:phaseQueue)
        {
            if(phaseAux.getId()==7 || phaseAux.getId()==8 || phaseAux.getId()==9) {
                phaseAux.decreaseNoOfCars();
                if (phaseAux.getNoOfCars() == 0)
                    phaseQueue.remove(phaseAux);
                return true;
            }
        }
        return false;
    }

    public void terminate()
    {
        running=false;
    }



   /* public TimeGap getClientOfThisWaitingTime(int waitingTime) {
        for (TimeGap temp : waitingQueue) {
            if (temp.getWaitingTime() == waitingTime)
                return temp;
        }
        return null;
    }*/
    public int getQueueId(){
        return this.id;
    }
    public PhaseQueue(int id) {
        this.id = id;
    }
    public int emptyQueueTimeForAllSimulation()
    {
        return SumCompletelyEmptyQueueTime;
    }



    public int emptyQueueTimeForInterval(int min,int maxi)
    {
        int sum=0;
        for(Integer i:completelyEmptyQueueTime)
        {
            if(i>=min && i<=maxi)
                sum++;
        }
        return sum;
    }
    public void addPhase(Phase phase) {
        phaseQueue.add(phase);

    }

    public void removeFirstPhase() {

        phaseQueue.remove(0);
    }



    public ArrayList<Phase> getQueue() {
        return phaseQueue;
    }

    public int getNumberOfPhasesInQueue() {
        return phaseQueue.size();
    }

    public void run() {
        int time=0;
       /* while(running) {

            if (waitingQueue.size() != 0) {
                getFirstElement().decrementServiceTime();
                if (getFirstElement().getServiceTime() == 0) {
                    emptyEvents+="Client number "+getFirstElement().getId()+" was removed at moment: "+time+ " from queue "+id+"\n";
                    emptyQueueTime.add(time);

                    removeFirstClient();
                }
            }
            else {
                completelyEmptyQueueTime.add(time);
                SumCompletelyEmptyQueueTime++;
            }
            try {
                sleep(1000);

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            time++;
        }
    */}


}
