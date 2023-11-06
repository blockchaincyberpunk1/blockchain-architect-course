import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256Example {

    // Function to calculate SHA-256 hash
    public static String calculateSHA256(String data) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data.getBytes());

        // Convert the byte array to a hexadecimal string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public static void main(String[] args) {
        try {
            String data = "Hello, Blockchain!";
            
            // Calculate SHA-256 hash
            String sha256Hash = calculateSHA256(data);
            
            System.out.println("Original Data: " + data);
            System.out.println("SHA-256 Hash: " + sha256Hash);
        } catch (NoSuchAlgorithmException e) {
            System.out.println("SHA-256 algorithm not available.");
        }
    }
}
