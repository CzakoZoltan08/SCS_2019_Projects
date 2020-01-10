package View;

import java.awt.Image;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class ORI_view extends JFrame {

	private JLabel imageLabel;
	private JButton prevButton;
	private JButton nextButton;
	
	int pos = 0;	// index of the first image

	public ORI_view() {

		this.setBounds(450, 190, 1441, 731); // the initial location where it should be rendered, last 2 parameters are width, height of the frame (without, it only hides the windows)

		getContentPane().setLayout(null);

		imageLabel = new JLabel("");
		imageLabel.setBounds(430, 0, 993, 619);
		getContentPane().add(imageLabel);

		
		prevButton = new JButton("<  Prev");
		prevButton.setBounds(802, 646, 97, 25);
		getContentPane().add(prevButton);
		prevButton.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				jButton_PreviousActionPerformed(evt);
			}
		});
		

		nextButton = new JButton("Next  >");
		nextButton.setBounds(966, 646, 97, 25);
		getContentPane().add(nextButton);
		nextButton.addActionListener(new java.awt.event.ActionListener() {
			public void actionPerformed(java.awt.event.ActionEvent evt) {
				jButton_NextActionPerformed(evt);
			}
		});
		
		
		// adding a fixed image
		JLabel imageLabel = new JLabel();
		Image img = new ImageIcon(this.getClass().getResource("/images/fixed_images/ori_img0.jpg")).getImage();
		imageLabel.setIcon(new ImageIcon(img));
		imageLabel.setBounds(0, 0, 418, 619);
		getContentPane().add(imageLabel);
		
		showImage(pos);		// display the first image from the folder when the window is opened
	}
	// until now, were just specified how the frame will look like when will be initialized

	// get images list
	// obtain a list of names of images from resource folder
	public String[] getImages() {
		File file = new File(getClass().getResource("/images/ori_operation/").getFile());
		String[] imagesList = file.list();
		return imagesList;
	}

	// display the image by index
	// parameter = index of the image in the list of names of images returned by
	// "getImages" method
	// retrieves the image and displays it into the JLabel
	public void showImage(int index) {
		String[] imagesList = getImages();
		String imageName = imagesList[index];
		ImageIcon icon = new ImageIcon(getClass().getResource("/images/ori_operation/" + imageName));
		Image image = icon.getImage().getScaledInstance(imageLabel.getWidth(), imageLabel.getHeight(), Image.SCALE_SMOOTH);
		imageLabel.setIcon(new ImageIcon(image));
	}

	// Next
	private void jButton_NextActionPerformed(java.awt.event.ActionEvent evt) {
		pos = pos + 1;
		if (pos >= getImages().length) {
			pos = getImages().length - 1;
		}
		showImage(pos);
	}

	// Previous
	private void jButton_PreviousActionPerformed(java.awt.event.ActionEvent evt) {
		pos = pos - 1;
		if (pos < 0) {
			pos = 0;
		}
		showImage(pos);
	}
}
