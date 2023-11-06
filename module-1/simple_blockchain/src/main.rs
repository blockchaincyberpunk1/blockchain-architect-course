// Import necessary libraries
use std::time::{SystemTime, UNIX_EPOCH};
use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};

// Define a Block struct
struct Block {
    index: u64,         // Index of the block in the blockchain
    timestamp: u64,     // Timestamp of when the block was created
    data: String,       // Data stored in the block
    previous_hash: u64, // Hash of the previous block in the blockchain
    hash: u64,          // Hash of the current block
}

// Implementation block for the Block struct
impl Block {
    // Constructor to create a new block
    fn new(index: u64, data: String, previous_hash: u64) -> Self {
        // Get the current timestamp in seconds since the Unix epoch
        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("Time went backwards")
            .as_secs();

        // Create a new hasher and hash the block components
        let mut hasher = DefaultHasher::new();
        index.hash(&mut hasher);
        timestamp.hash(&mut hasher);
        data.hash(&mut hasher);
        previous_hash.hash(&mut hasher);

        // Calculate the hash of the block
        let hash = hasher.finish();

        // Create and return a new Block instance
        Block {
            index,
            timestamp,
            data,
            previous_hash,
            hash,
        }
    }

    // Method to calculate the hash of the block
    fn calculate_hash(&self) -> u64 {
        let mut hasher = DefaultHasher::new();
        self.index.hash(&mut hasher);
        self.timestamp.hash(&mut hasher);
        self.data.hash(&mut hasher);
        self.previous_hash.hash(&mut hasher);

        // Calculate the hash and return it
        hasher.finish()
    }
}

// Define a Blockchain struct
struct Blockchain {
    chain: Vec<Block>, // A chain of blocks
}

// Implementation block for the Blockchain struct
impl Blockchain {
    // Constructor to create a new blockchain with a genesis block
    fn new() -> Self {
        // Create the genesis block with index 0, data "Genesis Block", and previous_hash 0
        let genesis_block = Block::new(0, "Genesis Block".to_string(), 0);
        
        // Initialize the blockchain with the genesis block
        Blockchain {
            chain: vec![genesis_block],
        }
    }

    // Method to add a new block to the blockchain
    fn add_block(&mut self, data: String) {
        // Get the previous block to determine the previous_hash
        let previous_block = &self.chain[self.chain.len() - 1];
        
        // Create a new block with the provided data and previous_hash
        let new_block = Block::new(previous_block.index + 1, data, previous_block.hash);
        
        // Add the new block to the blockchain
        self.chain.push(new_block);
    }

    // Method to check if the blockchain is valid
    fn is_chain_valid(&self) -> bool {
        for i in 1..self.chain.len() {
            let current_block = &self.chain[i];
            let previous_block = &self.chain[i - 1];

            // Check if the current block's hash matches the calculated hash
            if current_block.hash != current_block.calculate_hash() {
                return false;
            }

            // Check if the previous hash in the current block matches the hash of the previous block
            if current_block.previous_hash != previous_block.hash {
                return false;
            }
        }

        // If all checks pass, the blockchain is valid
        true
    }
}

fn main() {
    // Create a new blockchain
    let mut blockchain = Blockchain::new();

    // Add blocks to the blockchain
    blockchain.add_block("Transaction 1".to_string());
    blockchain.add_block("Transaction 2".to_string());

    // Check if the blockchain is valid and print the result
    println!("Blockchain is valid: {}", blockchain.is_chain_valid());

    // Tampering with data (commented out to prevent tampering)
    // let block_to_tamper = &mut blockchain.chain[1];
    // block_to_tamper.data = "Tampered Data".to_string();
    // block_to_tamper.hash = block_to_tamper.calculate_hash();

    // Check the validity again after tampering
    // println!("Blockchain is valid: {}", blockchain.is_chain_valid());
}
