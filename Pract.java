import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import utils.printUtils;

/**
 * Постановка задачі
 * <p>
 * Прочитати з stdin N рядків до появи EOF (максимум 10000 рядків).
 * Рядки розділяються АБО послідовністю байтів 0x0D та 0x0A (CR LF), або одним символом - 0x0D чи 0x0A.
 * Кожен рядок це пара "<key> <value>" (розділяються пробілом), де ключ - це текстовий ідентифікатор макс 16
 * символів (будь-які символи окрім white space chars - пробілу чи переводу на новий рядок), а значення -
 * це десяткове ціле знакове число в діапазоні [-10000, 10000].
 * Провести групування: заповнити два масиви (або масив структур з 2х значень) для зберігання пари <key> та <average> ,
 * які будуть включати лише унікальні значення <key> та <average> - це средне значення, обраховане для всіх <value>,
 * що відповідають конкретному значенню <key>.
 * Відсортувати алгоритмом bubble sort за <average>, та вивести в stdout  значення key від більших до менших
 * (average desc), кожен key окремим рядком.
 * Наприклад:
 * a1 1
 * a1 2
 * a1 3
 * a2 0
 * a2 10
 * Результат (average для a2=(0+10)/2=5, для a1=(1+2+3)/3 = 2):
 * a2
 * a1
 */

public class Pract {

    static class Pair {
        String key;
        double average;

        public Pair(String key, double average) {
            this.key = key;
            this.average = average;
        }
    }

    public static void main(String[] args) {

        String filePath = "D://santa/CA.txt";

        File file = new File(filePath);

        if (!file.exists()) {
            System.out.println("не знайдено");
            return;
        }

        List<Pair> pairs = new ArrayList<>();

        readAndSplitFile(file, pairs);

        Sort.bubbleSort(pairs);

        for (Pair pair : pairs) {
            System.out.println(pair.key + " " + pair.average);
        }

        System.out.println("Фінальний результат:");
        for (Pair pair : pairs) {
            System.out.println(pair.key);
        }
    }


    private static void readAndSplitFile(File file, List<Pair> pairs) {

        Map<String, List<Integer>> map = new HashMap<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = reader.readLine()) != null) {

                String[] parts = line.split(" ");

                if (parts.length == 2) {

                    String key = parts[0];

                    int value = Integer.parseInt(parts[1]);

                    if (!map.containsKey(key)) {
                        map.put(key, new ArrayList<>());
                    }
                    map.get(key).add(value);
                }
            }
        } catch (IOException e) {

            System.out.println("Сталася помилка " + e.getMessage());
        }

        for (Map.Entry<String, List<Integer>> entry : map.entrySet()) {

            String key = entry.getKey();

            List<Integer> values = entry.getValue();

            double average = Sort.calculateAverage(values);
            pairs.add(new Pair(key, average));

        }
    }

}


