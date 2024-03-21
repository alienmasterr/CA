package utils;

public class printUtils {

    /**
     * виводить масив без null
     * @param array
     */
    public static void printArray(Object[] array) {
        StringBuilder sb = new StringBuilder();
        for (Object obj : array) {

                sb.append(obj).append(" "); // prints every number one by one, separated by new line

        }
        System.out.println(sb);
    }
}
