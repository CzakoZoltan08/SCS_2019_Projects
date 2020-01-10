package View;

import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class Dashboard extends JFrame{
	
	private JButton mipsADD;
	private JButton mipsBEQ;
	private JButton mipsJUMP;
	private JButton mipsLW;
	private JButton mipsSW;
	private JButton mipsORI;
	
	public Dashboard() {
		
		this.setBounds(150, 190, 298, 491);		// initial location to be rendered: x,y, width, heights
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);		// TO MAKE THE CLOSING BUTTON [X] TO STOP THE APPLICATION (without, it only hides the windows)
		getContentPane().setLayout(null);
		
		mipsADD = new JButton("ADD operation");
		mipsADD.setBounds(32, 98, 206, 25);
		getContentPane().add(mipsADD);
		
		mipsBEQ = new JButton("BEQ operation");
		mipsBEQ.setBounds(32, 182, 206, 25);
		getContentPane().add(mipsBEQ);
		
		mipsJUMP = new JButton("JUMP operation");
		mipsJUMP.setBounds(32, 389, 206, 25);
		getContentPane().add(mipsJUMP);
		
		mipsLW = new JButton("LW operation");
		mipsLW.setBounds(32, 220, 206, 25);
		getContentPane().add(mipsLW);

		mipsSW = new JButton("SW operation");
		mipsSW.setBounds(32, 258, 206, 25);
		getContentPane().add(mipsSW);
		
		mipsORI = new JButton("ORI operation");
		mipsORI.setBounds(32, 296, 206, 25);
		getContentPane().add(mipsORI);
		
		JLabel lblRtypeInstruction = new JLabel("R-type");
		lblRtypeInstruction.setBounds(32, 69, 44, 16);
		getContentPane().add(lblRtypeInstruction);
		
		JLabel lblItypeInstructions = new JLabel("I-type");
		lblItypeInstructions.setBounds(32, 153, 44, 16);
		getContentPane().add(lblItypeInstructions);
		
		JLabel lblMipsMulticycleInstructions = new JLabel("MIPS Multicycle Instructions");
		lblMipsMulticycleInstructions.setBounds(60, 13, 163, 16);
		getContentPane().add(lblMipsMulticycleInstructions);
		
		JLabel lblJtype = new JLabel("J-type");
		lblJtype.setBounds(32, 360, 44, 16);
		getContentPane().add(lblJtype);
	}
	
	// action listeners for the buttons
	public void addADDoperationButtonActionListener(final ActionListener e) {
		mipsADD.addActionListener(e);
	}
	
	public void addBEQoperationButtonActionListener(final ActionListener e) {
		mipsBEQ.addActionListener(e);
	}
	
	public void addJUMPoperationButtonActionListener(final ActionListener e) {
		mipsJUMP.addActionListener(e);
	}
	
	public void addLWoperationButtonActionListener(final ActionListener e) {
		mipsLW.addActionListener(e);
	}
	
	public void addSWoperationButtonActionListener(final ActionListener e) {
		mipsSW.addActionListener(e);
	}
	
	public void addORIoperationButtonActionListener(final ActionListener e) {
		mipsORI.addActionListener(e);
	}	
}
