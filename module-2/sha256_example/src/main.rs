extern crate sha2; // Import the sha2 crate

use sha2::Digest; // Import the Digest trait from sha2

fn calculate_sha256(data: &str) -> String {
    let mut sha256 = sha2::Sha256::new(); // Create a new Sha256 hasher

    sha256.update(data.as_bytes()); // Input the data as bytes

    let sha256_hash = sha256.finalize(); // Finalize the hash computation

    // Format the hash as a hexadecimal string
    let result = format!("{:x}", sha256_hash);

    result
}

fn main() {
    let data = "Hello, Blockchain!";

    let sha256_hash = calculate_sha256(data);

    println!("Original Data: {}", data);
    println!("SHA-256 Hash: {}", sha256_hash);
}
