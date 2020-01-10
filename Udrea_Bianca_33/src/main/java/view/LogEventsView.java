package view;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;

public class LogEventsView extends JFrame {
    private JTextArea label1;
    private JLabel label2;
    private JLabel label3;
    private JButton btnBack;
    public LogEventsView() {
        //setTitle("Time Gap Based Semaphore");
        setBounds(0, 0, 360, 900);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        getContentPane().setLayout(null);
        getContentPane().setBackground(Color.lightGray);

        label2 = new JLabel("Time Gap based Semaphore");
        label2.setBounds(0, 0, 500, 26);
        getContentPane().add(label2);
        label2.setFont(new Font("Courier", Font.BOLD,24));

        label3 = new JLabel("");
        label3.setBounds(0, 30, 500, 26);
        getContentPane().add(label3);
        label3.setFont(new Font("Courier", Font.BOLD,24));


        label1 = new JTextArea(" ");
        label1.setBounds(0, 70, 500, 810);
        getContentPane().add(label1);
        label1.setFont(new Font("Courier", Font.BOLD, 17));

//        btnBack = new JButton("Back");
//        btnBack.setBounds(520, 700, 100, 70);
//        getContentPane().add(btnBack);
//        btnBack.setFont(new Font("Courier", Font.BOLD,17));
    }
    public void setLogEvents(String value)
    {
        label1.setText(value);
    }
    public void setTime(String value)
    {
        label3.setText(value);
    }
    public void addBackButtonListener(final ActionListener actionListener) {
        btnBack.addActionListener(actionListener);
    }
}
