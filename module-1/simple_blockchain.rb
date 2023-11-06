require 'digest'  # Import the Digest library for SHA-256 hashing
require 'json'    # Import the JSON library for pretty-printing the blockchain

class Block
  attr_reader :index, :timestamp, :data, :previous_hash, :hash

  # Constructor for creating a new block
  def initialize(index, timestamp, data, previous_hash = '')
    @index = index                 # Block's index in the blockchain
    @timestamp = timestamp         # Timestamp of when the block is created
    @data = data                   # Data stored in the block (e.g., transactions)
    @previous_hash = previous_hash # Hash of the previous block in the chain
    @hash = calculate_hash         # Hash of the current block
  end

  # Calculate the hash of the block
  def calculate_hash
    sha = Digest::SHA256.new    # Create a new SHA-256 hash object
    sha.update("#{index}#{timestamp}#{data}#{previous_hash}")  # Update the hash with block data
    sha.hexdigest              # Get the hexadecimal representation of the hash
  end

  # Setter method for updating the previous_hash attribute
  def previous_hash=(value)
    @previous_hash = value
  end
end

class Blockchain
  attr_reader :chain

  # Initialize the blockchain with a genesis block
  def initialize
    @chain = [create_genesis_block]
  end

  # Create the genesis block, the first block in the blockchain
  def create_genesis_block
    Block.new(0, '01/01/2022', 'Genesis Block', '0')  # Genesis block has no previous hash
  end

  # Get the latest block in the blockchain
  def get_latest_block
    @chain.last
  end

  # Add a new block to the blockchain with provided data
  def add_block(data)
    # Create a new block with an incremented index, current timestamp, provided data,
    # and the hash of the latest block as the previous hash
    new_block = Block.new(@chain.length, Time.now.to_s, data, get_latest_block.hash)
    @chain << new_block  # Append the new block to the blockchain
  end

  # Check if the blockchain is valid by verifying hashes and previous hash links
  def is_chain_valid
    (1...@chain.length).each do |i|
      current_block = @chain[i]
      previous_block = @chain[i - 1]

      # Verify that the current block's hash matches the calculated hash
      return false unless current_block.hash == current_block.calculate_hash

      # Verify that the previous_hash in the current block matches the hash of the previous block
      return false unless current_block.previous_hash == previous_block.hash
    end

    true  # If all checks pass, the blockchain is considered valid
  end
end

# Create a new blockchain
my_blockchain = Blockchain.new

# Add some blocks to the blockchain
my_blockchain.add_block({ amount: 4 })  # Adding a block with data
my_blockchain.add_block({ amount: 8 })  # Adding another block with data

# Check if the blockchain is valid and print the result
puts 'Blockchain is valid: ' + my_blockchain.is_chain_valid.to_s

# Uncomment the lines below to attempt tampering with data (preventing this by making the block immutable)
# my_blockchain.chain[1].data = { amount: 1000 }
# my_blockchain.chain[1].hash = my_blockchain.chain[1].calculate_hash

# Print the blockchain in a JSON format
puts JSON.pretty_generate(my_blockchain.chain)
