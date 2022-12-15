public class helloWorld3 {
    public static void main(String[] args) {
        Str testString = "Hello, World!";
        Int testInt = 1;
        System.out.println(testString);
        System.out.println(testInt);
    }

    public static void notMain(String[] args) {
        Str testString = "Hello, World!";
        Int testInt = 1;

        if (testString == "a") {
            System.out.println(testString);
        }
        else {
            System.out.println(testInt);
        }
    }
}
