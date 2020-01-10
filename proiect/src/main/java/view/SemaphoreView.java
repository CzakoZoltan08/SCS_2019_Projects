package view;



import java.awt.*;
import java.awt.event.ActionListener;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class SemaphoreView extends JFrame{
    private JPanel jpanel;
    private ImageIcon image1;
    private BufferedImage myImage;
    private BufferedImage myImage1;
    private javax.swing.JPanel one;
    private JLabel label1;

    private Image img=null;
    private Graphics g;
    public SemaphoreView() {
        setTitle("Time Gap Semaphore");
        setBounds(100, 0, 1200, 800);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        myImage = null;
        try {
            myImage = ImageIO.read(new File("intersection.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        myImage1=null;
        try {
            myImage1 = ImageIO.read(new File("intersection1.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        setContentPane(new ImagePanel(myImage,0,0));

        label1 = new JLabel();
        label1.setBounds(0, 0, 1200, 800);
        getContentPane().add(label1);

    }
    public void setGreenToSemaphore2()
    {
        label1.setIcon(new ImageIcon("D:\\ALTELE\\faculta\\An III\\SCS\\proiect\\intersection2.png"));



    }
    public void setGreenToSemaphore4()
    {

        label1.setIcon(new ImageIcon("D:\\ALTELE\\faculta\\An III\\SCS\\proiect\\intersection4.png"));


    }
    public void setGreenToSemaphore1and3()
    {
        label1.setIcon(new ImageIcon("D:\\ALTELE\\faculta\\An III\\SCS\\proiect\\intersection1.png"));


    }
}

