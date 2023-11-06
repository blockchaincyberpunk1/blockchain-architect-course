import hashlib
import time

class Block:
    def __init__(self, index, previous_hash, timestamp, data, nonce=0):
        # Initialize a new block with the given parameters
        self.index = index
        self.previous_hash = previous_hash
        self.timestamp = timestamp
        self.data = data
        self.nonce = nonce
        self.hash = self.calculate_hash()  # Calculate and set the hash

    def calculate_hash(self):
        # Calculate the hash of the block's contents using SHA-256
        data = str(self.index) + self.previous_hash + str(self.timestamp) + self.data + str(self.nonce)
        return hashlib.sha256(data.encode()).hexdigest()

    def mine_block(self, difficulty):
        # Mine the block by finding a nonce that produces a hash with a prefix of zeros
        target = '0' * difficulty
        while self.hash[:difficulty] != target:
            self.nonce += 1
            self.hash = self.calculate_hash()

    def __str__(self):
        # String representation of the block for easy printing
        return f"Block {self.index} - Timestamp: {self.timestamp}, Nonce: {self.nonce}\nData: {self.data}\nHash: {self.hash}\nPrevious Hash: {self.previous_hash}"

class Blockchain:
    def __init__(self):
        # Initialize the blockchain with a genesis block
        self.chain = [self.create_genesis_block()]
        self.difficulty = 4  # Adjust the difficulty as needed

    def create_genesis_block(self):
        # Create the genesis block with predefined values
        return Block(0, "0", int(time.time()), "Genesis Block")

    def get_latest_block(self):
        # Get the latest block in the blockchain
        return self.chain[-1]

    def add_block(self, new_block):
        # Add a new block to the blockchain
        new_block.index = len(self.chain)
        new_block.previous_hash = self.get_latest_block().hash
        new_block.timestamp = int(time.time())
        new_block.mine_block(self.difficulty)
        self.chain.append(new_block)

    def is_chain_valid(self):
        # Check if the blockchain is valid by verifying hashes and previous hash links
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i - 1]

            if current_block.hash != current_block.calculate_hash():
                return False

            if current_block.previous_hash != previous_block.hash:
                return False

        return True

# Create a blockchain and add some blocks
my_blockchain = Blockchain()
my_blockchain.add_block(Block(1, my_blockchain.get_latest_block().hash, 0, "Transaction 1"))  # Pass the previous hash correctly
my_blockchain.add_block(Block(2, my_blockchain.get_latest_block().hash, 0, "Transaction 2"))  # Pass the previous hash correctly

# Display the blockchain
for block in my_blockchain.chain:
    print(block)
    print()

# Check if the blockchain is valid
print("Is blockchain valid?", my_blockchain.is_chain_valid())
