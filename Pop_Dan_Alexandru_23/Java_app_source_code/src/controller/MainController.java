package controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.UIManager;

import View.AddView;
import View.BeqView;
import View.Dashboard;
import View.JumpView;
import View.LW_view;
import View.ORI_view;
import View.SW_view;


public class MainController {

	private Dashboard dashboard;
	private AddView addView;
	private BeqView beqView;
	private JumpView jumpView;
	private LW_view lwView;
	private SW_view swView;
	private ORI_view oriView;

	public void start() {
		
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		dashboard = new Dashboard();
		dashboard.setTitle("Dashboard Window");
		
		addView = new AddView();
		addView.setTitle("ADD operation");
		
		beqView = new BeqView();
		beqView.setTitle("BEQ operation");
		
		jumpView = new JumpView();
		jumpView.setTitle("JUMP operation");
		
		lwView = new LW_view();
		lwView.setTitle("LW operation");
		
		swView = new SW_view();
		swView.setTitle("SW operation");
		
		oriView = new ORI_view();
		oriView.setTitle("ORI operation");
		
		initializeButtonListeners();

		// DISPLAY THE FRAME FOR THE USER:
		dashboard.setVisible(true);			// make visible the dashboard
	}

	
	// prepare the logic (the behavior)
	private void initializeButtonListeners() {
		
		dashboard.addADDoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addView.setVisible(true);
			}
		});
		
		dashboard.addBEQoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				beqView.setVisible(true);
			}
		});
		
		dashboard.addJUMPoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				jumpView.setVisible(true);
			}
		});
		
		dashboard.addSWoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				swView.setVisible(true);
			}
		});
		
		dashboard.addLWoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				lwView.setVisible(true);
			}
		});
		
		dashboard.addORIoperationButtonActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				oriView.setVisible(true);
			}
		});
		
	}

}