import java.util.ArrayList;
import java.util.List;

public class Sort {

    public static void bubbleSort(List<Pract.Pair> pairs) {
        for (int i = 0; i < pairs.size() - 1; i++) {
            for (int j = 0; j < pairs.size() - i - 1; j++) {
                if (pairs.get(j).average < pairs.get(j + 1).average) {
                    Pract.Pair temp = pairs.get(j);
                    pairs.set(j, pairs.get(j + 1));
                    pairs.set(j + 1, temp);
                }
            }
        }
    }

    public static double calculateAverage(List<Integer> values) {
        int sum = 0;
        for (int value : values) {
            sum += value;
        }
        return (double) sum / values.size();
    }

}
