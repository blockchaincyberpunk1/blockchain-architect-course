import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Example {

    // Function to calculate MD5 hash
    public static String calculateMD5(String data) throws NoSuchAlgorithmException {
        MessageDigest md5Digest = MessageDigest.getInstance("MD5");
        byte[] hashBytes = md5Digest.digest(data.getBytes());

        // Convert the byte array to a hexadecimal string
        StringBuilder hexString = new StringBuilder();
        for (byte hashByte : hashBytes) {
            String hex = Integer.toHexString(0xFF & hashByte);
            if (hex.length() == 1) {
                hexString.append("0");
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    public static void main(String[] args) {
        try {
            String data = "Hello, Blockchain!";
            
            // Calculate MD5 hash
            String md5Hash = calculateMD5(data);
            
            System.out.println("Original Data: " + data);
            System.out.println("MD5 Hash: " + md5Hash);
        } catch (NoSuchAlgorithmException e) {
            System.out.println("MD5 algorithm not available.");
        }
    }
}
