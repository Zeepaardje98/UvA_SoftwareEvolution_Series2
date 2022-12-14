public class helloWorldDouble {
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

    public static int different(String[] args) {
        int num = 0;
        for(int i = 0; i < 10; i++) {
            num += i;
            num += 2 * i;
        }
        return num;
    }


    public static void test(String[] args) {
        Str testString = "Hello, World!";
        Int testInt = 1;
        System.out.println(testString);
        System.out.println(testInt);
    }

    public static void tesets(String[] args) {
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
