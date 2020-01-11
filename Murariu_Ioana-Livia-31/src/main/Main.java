package main;

import controller.DrawLine;
import controller.FileProcess;
import view.MainView;

public class Main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		FileProcess control=new FileProcess();
		MainView view = new MainView();
		
		DrawLine draw = new DrawLine();
		draw.finalDrawing();
		
		view.getContentPane().add(draw);
		
		view.setVisible(true);
		//control.readFile();
		
	}

}
