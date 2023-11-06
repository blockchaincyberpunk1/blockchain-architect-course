# Import the required libraries
import hashlib
from Crypto.PublicKey import RSA
from Crypto.Signature import pkcs1_15

# Sample signed messages and their corresponding public keys
messages = ["Message 1", "Message 2", "Message 3"]
signatures = [
    "8e88b1e3e9a3d8ce0f53ca4c0381a5a0d6d50eef4e8d15d34e0acaf97e9035e0ce52d7a01d9a9f8d3d3b191eeb06d216c0a32d784f6b4381a2a6d686a72dbd35c",
    "a5293ed635ea6dbd9ed63157b2d15d68598e58c68dd97e8803d287d194d5b123ea65f8d002ee7c8275ec6569acdb3b74f65a1f46e6bc981894f75c9a98f2b3b4",
    "f39e325dbd8e5f56e5b03edf3ff77411efbde84e5e1ec0f9bbfa9a56ff71eac092c3df53420ce7fb217de34215d47888d7f07a2ec5a8dd68669dca862cb5a5ca",
]
public_keys = [
    "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzIfzouqS0UW9VnUBVc7Ef\nLLTzN+kfUsAAHf3j1FmsMcMM/G2KRy32m6V8i7A8q38se30qUgo8Q5g6uS19RzTR\nFc6r+eybUmbDzrptWuq3+0hQWx1Xu74SXf7EDOa9eqnpiB2NT0CwCEj7gP6kUIyH\nA2CMh0K9c2MW95YO18RdsqZgWztnHaknU+KzzNSCw45Blz72lM4xATl4y/THoCZ4\n4e3sgtyNTw7LXRRaJL7wAV92tm6qEYnZ6x5dRmWvVr6LzscovSiRz8dN2T3XrWap\nubwdNk/EW/ttQjOXIqEGxkZRPlhD5ObSaPO5dE5Fk6Rk/4p5HZ7d9kLyV9R4JGEX\nbwIDAQAB\n-----END PUBLIC KEY-----",
    "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1dErU8jORiIcRAakY4Vs\nw26VvdslTqITsFpSg2ex1Dfrh7yy1ZzTzgxEiPJxNEOc3LV3ZtZs/3BHZXLXsgAq\nxKxuvluYvIklAD9juMRdW1HP2AblcKAsWzv/UFRxWvX6FuBtLb/VbLhaAQym2GB/\nqtKQVtjb/TSd1eObqqmuXwSOyEbCZmR4R99l9nK6nI0io1MXTBk9wySLVJvTQUsw\nBAr3RlTjHz7xwMz0Hv5esLEf1D/1MJijcRo//6TlKJt54Xrh91iGfFNLtHdPhrji\n9x1X9+OaEi0AXJ0shNyXkkYJkPcRqBcSfwHOknOf5eFXnLz5EDSDZpYRjL7ZmCT0\nBwIDAQAB\n-----END PUBLIC KEY-----",
    "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzGDc7pj4EdpQlQVCX3uf\nOtcJk3SoBGvuvnhXuwd5vY9p5nc9QSMsw1B5G8N5VB9dI8zzqf9jkMM7VWMNzzg\nD2R1Sf87XBTIedl9qTAgI4a7gW+3Tcjvee1wnEikufkuzIB4F/MS4T3PlKFABrBh\nJwTg4wJXpBKTjPBoe5ULz7Rkc2x5fi3Hb5eSrrr0eeVq/QIC3k6NSR51YdYIdj0v\nwI7Qg1JeQvF7F9p+ey8A13wpNRn5WwPQ3LAcDvL8NEPyzr7t98I0YExS6iVGsO4R\n/5S7QudHdyUlsJfsixWi2t8d8S+IDKsGzez1FBCsiqE8lJRWpbwudbV5E6TWuad1\n+QIDAQAB\n-----END PUBLIC KEY-----",
]

# Function to verify a signature
def verify_signature(public_key, signature, message):
    try:
        # Import the RSA public key from the provided key string
        key = RSA.import_key(public_key)
        
        # Hash the message using SHA-256
        h = hashlib.sha256(message.encode()).digest()
        
        # Verify the signature
        pkcs1_15.new(key).verify(h, bytes.fromhex(signature))
        
        # If verification succeeds, return True
        return True
    except (ValueError, TypeError):
        # If there's an error during verification, return False
        return False

# Loop through the sample messages and their corresponding signatures and public keys
for i, message in enumerate(messages):
    is_valid = verify_signature(public_keys[i], signatures[i], message)
    if is_valid:
        print(f"Message {i + 1} is VALID")
    else:
        print(f"Message {i + 1} is NOT VALID")
