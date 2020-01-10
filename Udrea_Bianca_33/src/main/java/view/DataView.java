package view;



import java.awt.event.ActionListener;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JButton;
import javax.swing.JTextField;
import java.awt.Color;
import java.awt.Font;


    public class DataView extends JFrame{
        private JLabel label1;
        private JLabel label2;
        private JLabel label3;
        private JLabel label4;
        private JLabel label5;
        private JLabel label6;
        private JLabel label7;
        private JLabel label8;
        private JLabel label9;
        private JLabel label10;
        private JLabel label11;
        private JLabel label12;
        private JLabel label13;
        private JLabel label14;
        private JLabel label15;
        private JLabel label16;
        private JLabel label17;
        private JLabel label18;
        private JLabel label19;
        private JLabel label20;
        private JLabel label21;
        private JLabel label22;
        private JLabel label23;
        private JLabel label24;
        private JLabel label25;
        private JLabel label26;
        private JLabel label27;
        private JLabel label28;
        private JLabel label29;
        private JLabel label30;
        private JLabel label31;
        private JLabel label;
        private JLabel label32;
        private JTextField textField;
        private JTextField textField2;
        private JTextField textField3;
        private JTextField textField4;
        private JTextField textField5;
        private JTextField textField6;
        private JTextField textField7;
        private JTextField textField8;
        private JTextField textField9;
        private JTextField textField10;
        private JTextField textField11;
        private JTextField textField12;
        private JTextField textField13;
        private JTextField textField14;
        private JTextField textField15;
        private JTextField textField16;
        private JTextField textField17;
        private JTextField textField18;
        private JTextField textField19;
        private JTextField textField20;
        private JTextField textField21;
        private JTextField textField24;
        private JTextField textField22;
        private JTextField textField23;
        private JButton btnStart;
        private JButton btnReport;
        private JTextField textField1;

        public DataView() {
            setBounds(20, 70, 900, 800);
            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            getContentPane().setLayout(null);
            getContentPane().setBackground(Color.white);

            label = new JLabel("Intelligent system of semaphores");
            label.setBounds(200, 13, 500, 30);
            getContentPane().add(label);
            label.setFont(new Font("Courier", Font.BOLD,28));



            label2 = new JLabel("Time gap 1 for the first lane:");
            label2.setBounds(12, 120, 500, 18);
            getContentPane().add(label2);
            label2.setFont(new Font("Courier", Font.BOLD,17));

            textField1 = new JTextField();
            textField1.setBounds(12, 150, 100, 22);
            getContentPane().add(textField1);
            textField1.setColumns(10);

            label3 = new JLabel("Time gap 2 for the first lane:");
            label3.setBounds(12, 180, 300, 18);
            getContentPane().add(label3);
            label3.setFont(new Font("Courier", Font.BOLD,17));

            textField2 = new JTextField();
            textField2.setBounds(12, 210, 100, 22);
            getContentPane().add(textField2);
            textField2.setColumns(10);

            label4 = new JLabel("Time gap 3 for the first lane:");
            label4.setBounds(12, 240, 300, 18);
            getContentPane().add(label4);
            label4.setFont(new Font("Courier", Font.BOLD,17));

            textField3 = new JTextField();
            textField3.setBounds(12, 270, 100, 22);
            getContentPane().add(textField3);
            textField3.setColumns(10);




            label13 = new JLabel("Time gap 1 for the second lane:");
            label13.setBounds(12, 330, 300, 18);
            getContentPane().add(label13);
            label13.setFont(new Font("Courier", Font.BOLD,17));

            textField4 = new JTextField();
            textField4.setBounds(12, 360, 100, 22);
            getContentPane().add(textField4);
            textField4.setColumns(10);

            label14 = new JLabel("Time gap 2 for the second lane:");
            label14.setBounds(12, 390, 300, 18);
            getContentPane().add(label14);
            label14.setFont(new Font("Courier", Font.BOLD,17));

            textField5 = new JTextField();
            textField5.setBounds(12, 420, 100, 22);
            getContentPane().add(textField5);
            textField5.setColumns(10);

            label5 = new JLabel("Time gap 3 for second lane:");
            label5.setBounds(12, 450, 300, 18);
            getContentPane().add(label5);
            label5.setFont(new Font("Courier", Font.BOLD,17));

            textField6 = new JTextField();
            textField6.setBounds(12, 480, 100, 22);
            getContentPane().add(textField6);
            textField6.setColumns(10);



            label6 = new JLabel("Time gap 1 for third lane:");
            label6.setBounds(440, 120, 300, 18);
            getContentPane().add(label6);
            label6.setFont(new Font("Courier", Font.BOLD,17));

            textField7 = new JTextField();
            textField7.setBounds(440, 150, 100, 22);
            getContentPane().add(textField7);
            textField7.setColumns(10);

            label8 = new JLabel("Time gap 2 for third lane:");
            label8.setBounds(440, 180, 300, 18);
            getContentPane().add(label8);
            label8.setFont(new Font("Courier", Font.BOLD,17));

            textField8 = new JTextField();
            textField8.setBounds(440, 210, 100, 22);
            getContentPane().add(textField8);
            textField8.setColumns(10);

            label9 = new JLabel("Time gap 3 for third lane:");
            label9.setBounds(440, 240, 300, 18);
            getContentPane().add(label9);
            label9.setFont(new Font("Courier", Font.BOLD,17));

            textField9 = new JTextField();
            textField9.setBounds(440, 270, 100, 22);
            getContentPane().add(textField9);
            textField9.setColumns(10);



            label10 = new JLabel("Time gap 1 for the fourth lane:");
            label10.setBounds(440, 330, 300, 18);
            getContentPane().add(label10);
            label10.setFont(new Font("Courier", Font.BOLD,17));

            textField10 = new JTextField();
            textField10.setBounds(440, 360, 100, 22);
            getContentPane().add(textField10);
            textField10.setColumns(10);

            label11 = new JLabel("Time gap 2 for the fourth lane:");
            label11.setBounds(440, 390, 300, 18);
            getContentPane().add(label11);
            label11.setFont(new Font("Courier", Font.BOLD,17));

            textField11 = new JTextField();
            textField11.setBounds(440, 420, 100, 22);
            getContentPane().add(textField11);
            textField11.setColumns(10);

            label12 = new JLabel("Time gap 3 for fourth lane:");
            label12.setBounds(440, 450, 300, 18);
            getContentPane().add(label12);
            label12.setFont(new Font("Courier", Font.BOLD,17));

            textField12 = new JTextField();
            textField12.setBounds(440, 480, 100, 22);
            getContentPane().add(textField12);
            textField12.setColumns(10);




            label15 = new JLabel("+ no of cars");
            label15.setBounds(280, 330, 300, 18);
            getContentPane().add(label15);
            label15.setFont(new Font("Courier", Font.BOLD,17));

            textField13 = new JTextField();
            textField13.setBounds(280, 360, 100, 22);
            getContentPane().add(textField13);
            textField13.setColumns(10);

            label16 = new JLabel("+ no of cars");
            label16.setBounds(280, 390, 300, 18);
            getContentPane().add(label16);
            label16.setFont(new Font("Courier", Font.BOLD,17));

            textField14 = new JTextField();
            textField14.setBounds(280, 420, 100, 22);
            getContentPane().add(textField14);
            textField14.setColumns(10);

            label17 = new JLabel("+ no of cars");
            label17.setBounds(280, 450, 300, 18);
            getContentPane().add(label17);
            label17.setFont(new Font("Courier", Font.BOLD,17));

            textField15 = new JTextField();
            textField15.setBounds(280, 480, 100, 22);
            getContentPane().add(textField15);
            textField15.setColumns(10);





            label18 = new JLabel("+ no of cars");
            label18.setBounds(280, 120, 300, 18);
            getContentPane().add(label18);
            label18.setFont(new Font("Courier", Font.BOLD,17));

            textField16 = new JTextField();
            textField16.setBounds(280, 150, 100, 22);
            getContentPane().add(textField16);
            textField16.setColumns(10);

            label19 = new JLabel("+ no of cars");
            label19.setBounds(280, 180, 300, 18);
            getContentPane().add(label19);
            label19.setFont(new Font("Courier", Font.BOLD,17));

            textField17 = new JTextField();
            textField17.setBounds(280, 210, 100, 22);
            getContentPane().add(textField17);
            textField17.setColumns(10);

            label20 = new JLabel("+ no of cars");
            label20.setBounds(280, 240, 300, 18);
            getContentPane().add(label20);
            label20.setFont(new Font("Courier", Font.BOLD,17));

            textField18 = new JTextField();
            textField18.setBounds(280, 270, 100, 22);
            getContentPane().add(textField18);
            textField18.setColumns(10);




            label21 = new JLabel("+ no of cars");
            label21.setBounds(720, 120, 300, 18);
            getContentPane().add(label21);
            label21.setFont(new Font("Courier", Font.BOLD,17));

            textField19 = new JTextField();
            textField19.setBounds(720, 150, 100, 22);
            getContentPane().add(textField19);
            textField19.setColumns(10);

            label22 = new JLabel("+ no of cars");
            label22.setBounds(720, 180, 300, 18);
            getContentPane().add(label22);
            label22.setFont(new Font("Courier", Font.BOLD,17));

            textField20 = new JTextField();
            textField20.setBounds(720, 210, 100, 22);
            getContentPane().add(textField20);
            textField20.setColumns(10);

            label23 = new JLabel("+ no of cars");
            label23.setBounds(720, 240, 300, 18);
            getContentPane().add(label23);
            label23.setFont(new Font("Courier", Font.BOLD,17));

            textField21 = new JTextField();
            textField21.setBounds(720, 270, 100, 22);
            getContentPane().add(textField21);
            textField21.setColumns(10);


            label24 = new JLabel("+ no of cars");
            label24.setBounds(720, 330, 300, 18);
            getContentPane().add(label24);
            label24.setFont(new Font("Courier", Font.BOLD,17));

            textField22 = new JTextField();
            textField22.setBounds(720, 360, 100, 22);
            getContentPane().add(textField22);
            textField22.setColumns(10);

            label25 = new JLabel("+ no of cars");
            label25.setBounds(720, 390, 300, 18);
            getContentPane().add(label25);
            label25.setFont(new Font("Courier", Font.BOLD,17));

            textField23 = new JTextField();
            textField23.setBounds(720, 420, 100, 22);
            getContentPane().add(textField23);
            textField23.setColumns(10);

            label26 = new JLabel("+ no of cars");
            label26.setBounds(720, 450, 300, 18);
            getContentPane().add(label26);
            label26.setFont(new Font("Courier", Font.BOLD,17));

            textField24 = new JTextField();
            textField24.setBounds(720, 480, 100, 22);
            getContentPane().add(textField24);
            textField24.setColumns(10);


            btnStart = new JButton("START");
            btnStart.setBounds(400, 530, 100, 70);
            getContentPane().add(btnStart);
            btnStart.setFont(new Font("Courier", Font.BOLD,17));

            btnReport = new JButton("REPORT");
            btnReport.setBounds(380, 640, 140, 70);
            getContentPane().add(btnReport);
            btnReport.setFont(new Font("Courier", Font.BOLD,17));
        }
       public void addStartButtonListener(final ActionListener actionListener) {
            btnStart.addActionListener(actionListener);
        }
        public void addReportButtonListener(final ActionListener actionListener) {
            btnReport.addActionListener(actionListener);
        }
        public String getTotalTime()
        {
            return textField.getText();
        }
        public String getFirstLaneGap1()
        {
            return textField1.getText();
        }
        public String getFirstLaneGap2()
        {
            return textField2.getText();
        }
        public String getFirstLaneGap3()
        {
            return textField3.getText();
        }
        public String getSecondLaneGap1()
        {
            return textField4.getText();
        }
        public String getSecondLaneGap2()
        {
            return textField5.getText();
        }

        public String getSecondLaneGap3()
        {
            return textField6.getText();
        }
        public String getThirdLaneGap1()
        {
            return textField7.getText();
        }
        public String getThirdLaneGap2()
        {
            return textField8.getText();
        }
        public String getThirdLaneGap3()
        {
            return textField9.getText();
        }
        public String getFourthLaneGap1()
        {
            return textField10.getText();
        }
        public String getFourthLaneGap2()
        {
            return textField11.getText();
        }
        public String getFourthLaneGap3()
        {
            return textField12.getText();
        }
        public String getSecondNoOfCars1()
        {
            return textField13.getText();
        }
        public String getSecondNoOfCars2()
        {
            return textField14.getText();
        }
        public String getSecondNoOfCars3()
        {
            return textField15.getText();
        }

        public String getFirstNoOfCars1()
        {
            return textField16.getText();
        }
        public String getFirstNoOfCars2()
        {
            return textField17.getText();
        }
        public String getFirstNoOfCars3()
        {
            return textField18.getText();
        }
        public String getThirdNoOfCars1()
        {
            return textField19.getText();
        }
        public String getThirdNoOfCars2()
        {
            return textField20.getText();
        }
        public String getThirdNoOfCars3()
        {
            return textField21.getText();
        }
        public String getFourthNoOfCars1()
        {
            return textField22.getText();
        }
        public String getFourthNoOfCars2()
        {
            return textField23.getText();
        }
        public String getFourthNoOfCars3()
        {
            return textField24.getText();
        }
    }

