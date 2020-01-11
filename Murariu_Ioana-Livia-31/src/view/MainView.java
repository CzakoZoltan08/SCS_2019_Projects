package view;

import javax.swing.JFrame;

import controller.DrawLine;

public class MainView extends JFrame{

	public MainView() {
		
		// setting closing operation
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// setting size of the pop window
		this.setBounds(100, 100, 700, 500);

		// setting canvas for draw
		//this.getContentPane().add(new DrawLine());

		// set visibility
	
	}

}
