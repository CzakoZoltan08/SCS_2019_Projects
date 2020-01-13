public class MultithreadingExample implements Runnable{

    @Override
    public void run() {
        try{

            System.out.println("Thread"+Thread.currentThread().getName()+"is now running");
        }
        catch (Exception e){
            System.out.println("Exception");
        }
    }
}
