import hashlib

# Function to calculate MD5 hash
def calculate_md5(data):
    md5 = hashlib.md5()
    md5.update(data.encode('utf-8'))
    return md5.hexdigest()

# Example usage
if __name__ == "__main__":
    data = "Hello, Blockchain!"
    
    # Calculate MD5 hash
    md5_hash = calculate_md5(data)
    
    print("Original Data: ", data)
    print("MD5 Hash: ", md5_hash)
