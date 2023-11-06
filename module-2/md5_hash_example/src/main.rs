// Import the `md5` crate, which provides MD5 hashing functionality.
use md5::Digest;

// Define a function to calculate the MD5 hash of a given string and return it as a hexadecimal string.
fn calculate_md5(data: &str) -> String {
    // Create an MD5 hasher instance.
    let mut hasher = md5::Md5::new();

    // Update the hasher with the input data.
    hasher.update(data);

    // Finalize the hashing process and get the result as an array of bytes.
    let result = hasher.finalize();

    // Format the byte array as a hexadecimal string and return it.
    format!("{:x}", result)
}

fn main() {
    // Define the input data for which you want to calculate the MD5 hash.
    let data = "Hello, Blockchain!";

    // Calculate the MD5 hash of the input data using the `calculate_md5` function.
    let md5_hash = calculate_md5(data);

    // Print the original data and its MD5 hash to the console.
    println!("Original Data: {}", data);
    println!("MD5 Hash: {}", md5_hash);
}
