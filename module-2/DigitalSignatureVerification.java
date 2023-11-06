import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class DigitalSignatureVerification {

    public static void main(String[] args) {
        // Sample signed messages and their corresponding public keys
        String[] messages = {
            "Message 1",
            "Message 2",
            "Message 3"
        };
        
        String[] signatures = {
            "8e88b1e3e9a3d8ce0f53ca4c0381a5a0d6d50eef4e8d15d34e0acaf97e9035e0ce52d7a01d9a9f8d3d3b191eeb06d216c0a32d784f6b4381a2a6d686a72dbd35c",
            "a5293ed635ea6dbd9ed63157b2d15d68598e58c68dd97e8803d287d194d5b123ea65f8d002ee7c8275ec6569acdb3b74f65a1f46e6bc981894f75c9a98f2b3b4",
            "f39e325dbd8e5f56e5b03edf3ff77411efbde84e5e1ec0f9bbfa9a56ff71eac092c3df53420ce7fb217de34215d47888d7f07a2ec5a8dd68669dca862cb5a5ca"
        };
        
        String[] publicKeys = {
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzIfzouqS0UW9VnUBVc7Ef" +
            "LLTzN+kfUsAAHf3j1FmsMcMM/G2KRy32m6V8i7A8q38se30qUgo8Q5g6uS19RzTR" +
            "Fc6r+eybUmbDzrptWuq3+0hQWx1Xu74SXf7EDOa9eqnpiB2NT0CwCEj7gP6kUIyH" +
            "A2CMh0K9c2MW95YO18RdsqZgWztnHaknU+KzzNSCw45Blz72lM4xATl4y/THoCZ4" +
            "4e3sgtyNTw7LXRRaJL7wAV92tm6qEYnZ6x5dRmWvVr6LzscovSiRz8dN2T3XrWap" +
            "ubwdNk/EW/ttQjOXIqEGxkZRPlhD5ObSaPO5dE5Fk6Rk/4p5HZ7d9kLyV9R4JGEX" +
            "bwIDAQAB",
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1dErU8jORiIcRAakY4Vs" +
            "w26VvdslTqITsFpSg2ex1Dfrh7yy1ZzTzgxEiPJxNEOc3LV3ZtZs/3BHZXLXsgAq" +
            "xKxuvluYvIklAD9juMRdW1HP2AblcKAsWzv/UFRxWvX6FuBtLb/VbLhaAQym2GB/" +
            "qtKQVtjb/TSd1eObqqmuXwSOyEbCZmR4R99l9nK6nI0io1MXTBk9wySLVJvTQUsw" +
            "BAr3RlTjHz7xwMz0Hv5esLEf1D/1MJijcRo//6TlKJt54Xrh91iGfFNLtHdPhrji" +
            "9x1X9+OaEi0AXJ0shNyXkkYJkPcRqBcSfwHOknOf5eFXnLz5EDSDZpYRjL7ZmCT0" +
            "BwIDAQAB",
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzGDc7pj4EdpQlQVCX3uf" +
            "OtcJk3SoBGvuvnhXuwd5vY9p5nc9QSMsw1B5G8N5VB9dI8zzqf9jkMM7VWMNzzg" +
            "D2R1Sf87XBTIedl9qTAgI4a7gW+3Tcjvee1wnEikufkuzIB4F/MS4T3PlKFABrBh" +
            "JwTg4wJXpBKTjPBoe5ULz7Rkc2x5fi3Hb5eSrrr0eeVq/QIC3k6NSR51YdYIdj0v" +
            "wI7Qg1JeQvF7F9p+ey8A13wpNRn5WwPQ3LAcDvL8NEPyzr7t98I0YExS6iVGsO4R" +
            "/5S7QudHdyUlsJfsixWi2t8d8S+IDKsGzez1FBCsiqE8lJRWpbwudbV5E6TWuad1" +
            "+QIDAQAB"
        };
        
        for (int i = 0; i < messages.length; i++) {
            boolean isValid = verifySignature(publicKeys[i], messages[i], signatures[i]);
            if (isValid) {
                System.out.println("Message " + (i + 1) + " is VALID");
            } else {
                System.out.println("Message " + (i + 1) + " is NOT VALID");
            }
        }
    }

    public static boolean verifySignature(String publicKeyBase64, String message, String signature) {
        try {
            // Decode the public key
            byte[] publicKeyBytes = Base64.getDecoder().decode(publicKeyBase64);
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKey = keyFactory.generatePublic(keySpec);

            // Initialize a Signature object with the public key
            Signature sig = Signature.getInstance("SHA256withRSA");
            sig.initVerify(publicKey);

            // Update the Signature object with the message bytes
            sig.update(message.getBytes());

            // Decode the signature
            byte[] signatureBytes = Base64.getDecoder().decode(signature);

            // Verify the signature
            return sig.verify(signatureBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
