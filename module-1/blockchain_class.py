import hashlib
import json
from time import time

class Blockchain:
    def __init__(self):
        self.chain = []
        self.current_transactions = []

        # Create the genesis block
        self.new_block(previous_hash='1', proof=100)

    def new_block(self, proof, previous_hash=None):
        """
        Create a new block in the blockchain.

        :param proof: Proof of work value
        :param previous_hash: Hash of previous block
        :return: New block
        """
        block = {
            'index': len(self.chain) + 1,
            'timestamp': time(),
            'transactions': self.current_transactions,
            'proof': proof,
            'previous_hash': previous_hash or self.hash(self.chain[-1])
        }

        # Reset the current list of transactions
        self.current_transactions = []

        self.chain.append(block)
        return block

    def new_transaction(self, sender, recipient, amount):
        """
        Create a new transaction to be included in the next mined block.

        :param sender: Address of the sender
        :param recipient: Address of the recipient
        :param amount: Transaction amount
        :return: Index of the block that will hold this transaction
        """
        self.current_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
        })

        return self.last_block['index'] + 1

    @property
    def last_block(self):
        """
        Return the last block in the blockchain.

        :return: Last block
        """
        return self.chain[-1]

    @staticmethod
    def hash(block):
        """
        Create a SHA-256 hash of a block.

        :param block: Block
        :return: Hash string
        """
        # Sort the dictionary to ensure consistent hashes
        block_string = json.dumps(block, sort_keys=True).encode()
        return hashlib.sha256(block_string).hexdigest()


# Instantiate the blockchain
blockchain = Blockchain()

# Create some example transactions
blockchain.new_transaction("Alice", "Bob", 5)
blockchain.new_transaction("Bob", "Charlie", 3)
blockchain.new_transaction("Alice", "Eve", 2)

# Mine a new block with a proof of work (for simplicity, we use a constant proof here)
proof = 12345
previous_hash = blockchain.hash(blockchain.last_block)
blockchain.new_block(proof, previous_hash)

# Print the blockchain
print("Blockchain:")
print(json.dumps(blockchain.chain, indent=2))
