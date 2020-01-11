package controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import model.Segment;

public class FileProcess {

	private List<Segment> segments = new ArrayList<>();
	private String fileName = "C:/Users/Livia/eclipse-workspace/CuttingSoftware/data.txt";

	public FileProcess() {

	}

	public void readFile() {
		Path path = Paths.get(fileName);
		Stream<String> stream;
		try {
			stream = Files.lines(path);
			stream.forEachOrdered(s -> segments.add(
					new Segment(s.split(" ")[0], Integer.valueOf(s.split(" ")[1]), Integer.valueOf(s.split(" ")[2]),
							Integer.valueOf(s.split(" ")[3]), Integer.valueOf(s.split(" ")[4]))));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for (Segment i : segments) {
			System.out.println(i.getSegType() + " " + i.getBeginX() + " " + i.getBeginY() + " " + i.getEndX() + " "
					+ i.getEndY() + " ");
		}

	}

	public List<Segment> getSegments() {
		return segments;
	}

	public void setSegments(List<Segment> segments) {
		this.segments = segments;
	}

}
