from cryptography.fernet import Fernet

# Generate a symmetric key
key = Fernet.generate_key()
cipher_suite = Fernet(key)

# Message to be encrypted
message = b"Hello, this is a secret message!"

# Encrypt the message
cipher_text = cipher_suite.encrypt(message)

# Decrypt the message
plain_text = cipher_suite.decrypt(cipher_text)

# Display the results
print("Original Message:", message.decode())
print("Cipher Text:", cipher_text)
print("Decrypted Message:", plain_text.decode())
