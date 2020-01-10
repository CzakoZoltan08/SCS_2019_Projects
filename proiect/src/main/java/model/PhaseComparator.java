package model;
import java.util.Comparator;

public class PhaseComparator implements Comparator<Phase> {
    @Override
    public int compare(Phase a, Phase b) {

        return a.getTimeGap() - b.getTimeGap();
    }
}