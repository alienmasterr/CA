import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public final class DataInput {

    private static void writeText(String wr){
        if (wr == null)
            System.out.print("Введіть дані: ");
        else
            System.out.print(wr);
    }

    public static Long getLong() throws IOException{
        String s = getString();
        Long value = Long.valueOf(s);
        return value;
    }
    /*
    public static char getChar() {
        try {
            String s = getString();
            return s.charAt(0);
        } catch (IOException e) {
            e.printStackTrace();
            // Handle the exception as needed
            return '\0'; // Return a default value (null character) in case of an exception
        }
    }
*/
    public static char getChar() throws IOException{
        String s = getString();
        return s.charAt(0);
    }

    /*
            public static Integer getInt(String wr){
                writeText(wr);
                String s = "";
                try {
                    s = getString();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                Integer value = Integer.valueOf(s);
                return value;

            }

        public static Integer getInt() {

            writeText("Enter an integer:");
            String s = "";
            try {
                s = getString();
            } catch (IOException e) {
                e.printStackTrace();
                // Handle the exception as needed
            }

            try {
                Integer value = Integer.valueOf(s);
                return value;
            } catch (NumberFormatException e) {
                // Handle the case where the input is not a valid integer
                e.printStackTrace();
                return null; // Or throw an exception, return a default value, etc.
            }
        }

    public static Integer getInt() {
        writeText("integer:");
        String s = getString();

        try {
            Integer value = Integer.valueOf(s);
            return value;
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return null;
        }
    }
    */
    public static Integer getInt() {
        while (true) {
           // writeText("integer:");
            String s = getString();

            try {
                Integer value = Integer.valueOf(s);
                return value;
            } catch (NumberFormatException e) {
                System.out.println("Це не integer. Спробуйте ще раз.");
            }
        }
    }
    public static String getString() {
        String s = "";
        try {
            InputStreamReader isr = new InputStreamReader(System.in);
            BufferedReader br = new BufferedReader(isr);
            s = br.readLine();
        }catch (IOException ex){
            System.out.println("Can't read the string");
            System.exit(0);
        }
        return s;
    }

    public static Double getDouble() {
        writeText("grade:");
        String s = getString();

        try {
            return Double.valueOf(s);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            // Handle the case where the input is not a valid double
            System.out.println("Invalid input. Please enter a valid double.");
            return null; // Or throw an exception, return a default value, etc.
        }


    }



}