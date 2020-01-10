package view;

import javax.swing.*;
import java.awt.*;

class ImagePanel extends JComponent {
    private Image image;
    private int x;
    private int y;
    public ImagePanel(Image image,int x,int y) {
        this.x=x;
        this.y=y;
        this.image = image;
    }
    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawImage(image, x, y, this);
    }
}