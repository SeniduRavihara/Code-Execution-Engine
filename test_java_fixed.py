import base64

code = '''public class Main {
    public static void main(String[] args) {
        int[] arr = {64, 34, 25, 12, 22};
        int n = arr.length;
        
        for (int i = 0; i < n-1; i++) {
            for (int j = 0; j < n-i-1; j++) {
                if (arr[j] > arr[j+1]) {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }
        
        System.out.print("Sorted: ");
        for (int x : arr) {
            System.out.print(x + " ");
        }
        System.out.println();
        System.out.println("Time: O(n^2)");
    }
}'''

encoded = base64.b64encode(code.encode()).decode()
print(encoded)
