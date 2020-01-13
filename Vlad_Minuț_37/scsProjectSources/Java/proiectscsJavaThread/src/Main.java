public class Main {
    public static void main(String[] args) {

        double startTime = System.nanoTime();
        int noThreads = 10000;
        Thread[] threadsArray = new Thread[noThreads];
        for(int i = 0; i<noThreads;i++)
        {
            threadsArray[i] = new Thread(new MultithreadingExample());
            threadsArray[i].start();
        }
        for (int i=0; i<noThreads;i++)
        {
            try {
                threadsArray[i].join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        double elapsedTime = System.nanoTime() - startTime;

        elapsedTime/=1000000000;

        System.out.println(elapsedTime);
    }
}
