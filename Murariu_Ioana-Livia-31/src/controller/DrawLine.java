package controller;

import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;
import javax.swing.Timer;
import java.util.concurrent.TimeUnit;

import javax.swing.JComponent;
import javax.swing.JOptionPane;

import model.Coordinates;
import model.Segment;

public class DrawLine extends JComponent {

	FileProcess file = new FileProcess();
	private List<Coordinates> coords = new ArrayList<>();
	private Timer animationTimer;
	private int size;
	private int currSize;

	public void Bresenham() {
		file.readFile();
		for (Segment s : file.getSegments()) {
			if (s.getSegType().equals("str")) {
				int x, y, dx, dy, swap, aux, s1, s2, p, i;
				x = s.getBeginX();
				y = s.getBeginY();

				assert s.getBeginX() > 0 && s.getBeginX() < 700 && s.getEndX() > 0 && s.getEndX() < 700
						&& s.getBeginY() > 0 && s.getBeginY() < 500 && s.getEndY() > 0
						&& s.getEndY() < 500 : invalidSize();

				if (s.getEndX() == s.getBeginX())
					dx = 100;
				else
					dx = Math.abs(s.getEndX() - s.getBeginX());
				if (s.getEndY() == s.getBeginY())
					dy = 100;
				else
					dy = Math.abs(s.getEndY() - s.getBeginY());
				s1 = (int) Math.signum(s.getEndX() - s.getBeginX());
				s2 = (int) Math.signum(s.getEndY() - s.getBeginY());
				swap = 0;
				coords.add(new Coordinates(s.getBeginX(), s.getBeginY()));
				if (dx > dy) {
					aux = dx;
					dx = dy;
					dy = aux;
					swap = 1;
				}
				p = 2 * dy - dx;
				for (i = 0; i < dx; i++) {
					coords.add(new Coordinates(x, y));

					while (p >= 0) {
						p = p - 2 * dx;
						if (swap != 0)
							x += s1;
						else
							y += s2;
					}
					p = p + 2 * dy;
					if (swap != 0)
						y += s2;
					else
						x += s1;
				}
				coords.add(new Coordinates(s.getEndX(), s.getEndY()));
			}
			if (s.getSegType().equals("cir")) {

				/*
				 * Consider s.getBeginX() and s.getBeginY() the parameters of the center of the
				 * circle
				 * 
				 * Consider s.getEndY() the radius of the circle
				 * 
				 * Consider s.getEndX() the quadrant in which is the circle arc
				 */
				int r = s.getEndY();
				int x = 0, y = r;
				int d = 3 - 2 * r;

				assert s.getEndX() == 1 || s.getEndX() == 2 || s.getEndX() == 3 || s.getEndX() == 4 || s.getEndX() == 5
						|| s.getEndX() == 6 || s.getEndX() == 7 || s.getEndX() == 8 : invalidQuadrant();

				switch (s.getEndX()) {
				case 1:
					coords.add(new Coordinates(s.getBeginX() + x, s.getBeginY() - y));
					break;
				case 2:
					coords.add(new Coordinates(s.getBeginX() + y, s.getBeginY() - x));
					break;
				case 3:
					coords.add(new Coordinates(s.getBeginX() + x, s.getBeginY() + y));
					break;
				case 4:
					coords.add(new Coordinates(s.getBeginX() + y, s.getBeginY() + x));
					break;
				case 5:
					coords.add(new Coordinates(s.getBeginX() - x, s.getBeginY() + y));
					break;
				case 6:
					coords.add(new Coordinates(s.getBeginX() - y, s.getBeginY() + x));
					break;
				case 7:
					coords.add(new Coordinates(s.getBeginX() - y, s.getBeginY() - x));
					break;
				case 8:
					coords.add(new Coordinates(s.getBeginX() - x, s.getBeginY() - y));
					break;

				}

				while (x <= y) {
					x++;

					// check for decision parameter
					// and correspondingly
					// update d, x, y
					if (d > 0) {
						y--;
						d = d + 4 * (x - y) + 10;
					} else
						d = d + 4 * x + 6;

					switch (s.getEndX()) {
					case 1:
						coords.add(new Coordinates(s.getBeginX() + x, s.getBeginY() - y));
						break;
					case 2:
						coords.add(new Coordinates(s.getBeginX() + y, s.getBeginY() - x));
						break;
					case 3:
						coords.add(new Coordinates(s.getBeginX() + x, s.getBeginY() + y));
						break;
					case 4:
						coords.add(new Coordinates(s.getBeginX() + y, s.getBeginY() + x));
						break;
					case 5:
						coords.add(new Coordinates(s.getBeginX() - x, s.getBeginY() + y));
						break;
					case 6:
						coords.add(new Coordinates(s.getBeginX() - y, s.getBeginY() + x));
						break;
					case 7:
						coords.add(new Coordinates(s.getBeginX() - y, s.getBeginY() - x));
						break;
					case 8:
						coords.add(new Coordinates(s.getBeginX() - x, s.getBeginY() - y));
						break;

					}

				}

			}
		}
	}

	public void setSize(int size) {
		this.size = size;
	}

	@Override
	public void paintComponent(Graphics g) {

		super.paintComponent(g);

		for (int i = 0; i < 50; ++i) {
			g.drawLine(0, i * 10, 700, i * 10);
		}
		for (int i = 0; i < 70; ++i) {
			g.drawLine(i * 10, 0, i * 10, 500);
		}

		for (int i = 0; i < size; ++i)
			g.drawRect(coords.get(i).getxCoordinate(), coords.get(i).getyCoordinate(), 1, 1);

	}

	public void repainting() {
		// for (int i=0;i<coords.size();++i) {
		currSize++;
		if (currSize < coords.size()) {
			setSize(currSize);
			repaint();
		}
		// }
	}

	public void finalDrawing() {
		Bresenham();
		class TimeListener implements ActionListener {

			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				repainting();
			}

		}
		ActionListener listener = new TimeListener();
		Timer timer = new Timer(10, listener);
		timer.start();

	}

	public int invalidQuadrant() {
		JOptionPane.showMessageDialog(null, "Invalid Quadrant: please pick a number from 1 to 8");
		return 0;
	}

	public int invalidSize() {
		JOptionPane.showMessageDialog(null, "Invalid Inputs: the image is outside the panel");
		return 0;
	}

}
