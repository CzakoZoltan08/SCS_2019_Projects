package model;

public class Phase implements Comparable<Phase>{
    private int id;
    private int noOfCars;
    private int timeGap;
    private int secondsPaused=0;
    private Semaphore semaphore;

    public void setSecondsPaused(int secondsPaused) {
        this.secondsPaused = secondsPaused;
    }

    public Phase(int id, Semaphore semaphore, int timeGap, int noOfCars) {
        this.id = id;
        this.timeGap = timeGap;
        this.noOfCars=noOfCars;
        this.semaphore=semaphore;
    }
    public void increaseSecondsPassed()
    {
        secondsPaused--;
    }
    public int getNoOfCarsWaiting()
    {
        if(secondsPaused>0)
            return 0;
        else return noOfCars;
    }
    public Semaphore getSemaphore() {
        return semaphore;
    }

    public void setSemaphore(Semaphore semaphore) {
        this.semaphore = semaphore;
    }

    public int getNoOfCars() {
        return noOfCars;
    }

    public void decreaseNoOfCars()
    {
        this.noOfCars--;
    }
    public void setNoOfCars(int noOfCars) {
        this.noOfCars = noOfCars;
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTimeGap() {
        return timeGap;
    }

    public void setTimeGap(int timeGap) {
        this.timeGap = timeGap;
    }

    @Override
    public int compareTo(Phase o) {
        //return this.timeGap-o.getTimeGap();
        if (this.timeGap >= o.getTimeGap())
            return 1;
        else if (this.timeGap < o.getTimeGap())
            return -1;
        return 0;
    }
}
