import java.text.DecimalFormat;
import java.util.Random;

public class BubbleSort
{
    void bubbleSort(int arr[])
    {
        int n = arr.length;
        for (int i = 0; i < n-1; i++)
            for (int j = 0; j < n-i-1; j++)
                if (arr[j] > arr[j+1])
                {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
    }

    void printArray(int arr[])
    {
        int n = arr.length;
        for (int i=0; i<n; ++i)
            System.out.print(arr[i] + " ");
        System.out.println();
    }

    public static void main(String args[])
    {

        BubbleSort ob = new BubbleSort();
        int n = 10000;
        int [] arr = new int[n];
        Random rd = new Random();
        for(int i=0; i<n; ++i)
        {
            arr[i] = rd.nextInt()%100000;
        }
        double startTime = System.nanoTime();
        ob.bubbleSort(arr);

        double elapsedTime = System.nanoTime() - startTime;

        elapsedTime/=1000000000;
        System.out.println("Sorted array");
        //ob.printArray(arr);
        System.out.println(new DecimalFormat("#.##########").format(elapsedTime));
    }
}