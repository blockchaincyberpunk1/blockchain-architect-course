import hashlib

# Function to calculate SHA-256 hash
def calculate_sha256(data):
    sha256 = hashlib.sha256()
    sha256.update(data.encode('utf-8'))
    return sha256.hexdigest()

# Example usage
if __name__ == "__main__":
    data = "Hello, Blockchain!"
    
    # Calculate SHA-256 hash
    sha256_hash = calculate_sha256(data)
    
    print("Original Data: ", data)
    print("SHA-256 Hash: ", sha256_hash)
