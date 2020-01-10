package view;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;

public class FinalReportView extends JFrame {
    private JTextArea label1;
    private JLabel label2;
    private JLabel label4;
    private JLabel label5;
    private JTextArea label3;
    private JTextArea label6;
    private JTextArea label7;
    private JButton btnBack;
    public FinalReportView() {
        //setTitle("Time Gap Based Semaphore");
        setBounds(0, 0, 1100, 900);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        getContentPane().setLayout(null);
        getContentPane().setBackground(Color.lightGray);

        label2 = new JLabel("Final Report and Comparison of Results");
        label2.setBounds(0, 0, 700, 26);
        getContentPane().add(label2);
        label2.setFont(new Font("Courier", Font.BOLD,24));


        label4 = new JLabel("Time Gap Based Semaphore");
        label4.setBounds(10, 30, 500, 26);
        getContentPane().add(label4);
        label4.setFont(new Font("Courier", Font.BOLD,22));

        label5 = new JLabel("Classic Semaphore");
        label5.setBounds(570, 30, 500, 26);
        getContentPane().add(label5);
        label5.setFont(new Font("Courier", Font.BOLD,22));

        label1 = new JTextArea(" ");
        label1.setBounds(10, 70, 500, 680);
        getContentPane().add(label1);
        label1.setFont(new Font("Courier", Font.BOLD, 17));

        label3 = new JTextArea(" ");
        label3.setBounds(570, 70, 500, 680);
        getContentPane().add(label3);
        label3.setFont(new Font("Courier", Font.BOLD, 17));

        label6 = new JTextArea(" ");
        label6.setBounds(10, 770, 530, 40);
        getContentPane().add(label6);
        label6.setFont(new Font("Courier", Font.BOLD, 17));

        label7 = new JTextArea(" ");
        label7.setBounds(570, 770, 530, 40);
        getContentPane().add(label7);
        label7.setFont(new Font("Courier", Font.BOLD, 17));

//        btnBack = new JButton("Back");
//        btnBack.setBounds(520, 700, 100, 70);
//        getContentPane().add(btnBack);
//        btnBack.setFont(new Font("Courier", Font.BOLD,17));
    }
    public void setReportFirstSemaphore(String value)
    {
        label1.setText(value);
    }
    public void setReportSecondSemaphore(String value)
    {
        label3.setText(value);
    }
    public void setConclusionFirstSemaphore(String value)
    {
        label6.setText(value);
    }
    public void setConclusionSecondSemaphore(String value)
    {
        label7.setText(value);
    }
}
