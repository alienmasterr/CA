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

    public static void main(String[] args) {

        String filePath = "D://santa/CA.txt";

        File file = new File(filePath);

        if (!file.exists()) {
            System.out.println("не знайдено");
            return;
        }

        List<String> keys = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        readAndSplitFile(file, keys, values);


        System.out.println("Ключі: " + keys);
        System.out.println("Значення: " + values);
    }

    private static void readAndSplitFile(File file, List<String> keys, List<Integer> values) {
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {

                String[] parts = line.split(" ");
                if (parts.length == 2) {

                    keys.add(parts[0]);
                    values.add(Integer.parseInt(parts[1]));
                }
            }
        } catch (IOException e) {
            System.out.println("Сталася помилка " + e.getMessage());
        }
    }

}


//        int size = DataInput.getInt();
//        String[] keys = new String[size];
//        int[] values = new int[size];
//
//        int end = 0;
//
//        for (int i = 0; i < keys.length; i++) {
//            String key = DataInput.getString();
//            int value = DataInput.getInt();
//            keys[i]= key;
//            values[i] = value;
//            System.out.println("1 для переривання циклу");
//            end = DataInput.getInt();
//
//            if (end == 1) {
//                break;
//            }
//        }
//        printUtils.printArray(keys);

//        int end = 0;
//        Dictionary<String, Integer> dict = new Hashtable<>();
//    while (end != 1) {
//        String key = DataInput.getString();
//        int value = DataInput.getInt();
//
//
//        dict.put(key, value);
//        end = DataInput.getInt();
//    }
//        System.out.println(dict);

//        Enumeration<String> k = dict.keys();
//        while (k.hasMoreElements()) {
//            //String key = k.nextElement();
//           for (int i=0; i<dict.size(); i++){
//
//           }
////
////            System.out.println("Key: " + key + ", Value: "
////                    + dict.get(key));
//        }



