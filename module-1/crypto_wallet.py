import hashlib
import json
from time import time
from uuid import uuid4
from flask import Flask, jsonify, request

# Define a class for the blockchain.
class Blockchain:
    def __init__(self):
        self.chain = []                   # List to store blocks
        self.current_transactions = []    # List to store pending transactions
        self.nodes = set()                # Set to store network nodes
        self.create_block(previous_hash='1', proof=100)  # Create the genesis block

    # Create a new block in the blockchain.
    def create_block(self, proof, previous_hash):
        block = {
            'index': len(self.chain) + 1,
            'timestamp': time(),
            'transactions': self.current_transactions,
            'proof': proof,
            'previous_hash': previous_hash or self.hash(self.chain[-1]),
        }
        self.current_transactions = []     # Clear pending transactions
        self.chain.append(block)
        return block

    # Create a new transaction and add it to the list of pending transactions.
    def create_transaction(self, sender, recipient, amount):
        self.current_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
        })
        return self.last_block['index'] + 1

    # Hash a block using SHA-256.
    def hash(self, block):
        return hashlib.sha256(json.dumps(block, sort_keys=True).encode()).hexdigest()

    # Get the last block in the blockchain.
    @property
    def last_block(self):
        return self.chain[-1]

    # Perform the proof-of-work to find a valid proof.
    def proof_of_work(self, last_proof):
        proof = 0
        while self.valid_proof(last_proof, proof) is False:
            proof += 1
        return proof

    # Validate a proof: check if the hash starts with four leading zeros.
    @staticmethod
    def valid_proof(last_proof, proof):
        guess = f'{last_proof}{proof}'.encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"

# Instantiate the Flask app.
app = Flask(__name__)

# Instantiate the blockchain.
blockchain = Blockchain()

# Generate a globally unique address for this node.
node_identifier = str(uuid4()).replace('-', '')

# Define a route for mining a new block.
@app.route('/mine', methods=['GET'])
def mine_route():
    response = mine()
    return jsonify(response), 200

# Define a route for creating a new transaction.
@app.route('/transactions/new', methods=['POST'])
def new_transaction_route():
    values = request.get_json()
    required = ['sender', 'recipient', 'amount']
    if not all(k in values for k in required):
        return 'Missing values', 400

    response = new_transaction(values['sender'], values['recipient'], values['amount'])
    return jsonify(response), 201

# Define a route for retrieving the full chain.
@app.route('/chain', methods=['GET'])
def full_chain_route():
    response = full_chain()
    return jsonify(response), 200

# Define a function to mine a new block.
def mine():
    last_block = blockchain.last_block
    last_proof = last_block['proof']
    proof = blockchain.proof_of_work(last_proof)

    # Reward the miner by adding a transaction.
    blockchain.create_transaction(
        sender="0",
        recipient=node_identifier,
        amount=1,
    )

    previous_hash = blockchain.hash(last_block)
    block = blockchain.create_block(proof, previous_hash)

    response = {
        'message': 'New Block Forged',
        'index': block['index'],
        'transactions': block['transactions'],
        'proof': block['proof'],
        'previous_hash': block['previous_hash'],
    }
    return response

# Define a function to create a new transaction.
def new_transaction(sender, recipient, amount):
    index = blockchain.create_transaction(sender, recipient, amount)
    response = {'message': f'Transaction will be added to Block {index}'}
    return response

# Define a function to retrieve the full chain.
def full_chain():
    response = {
        'chain': blockchain.chain,
        'length': len(blockchain.chain),
    }
    return response

if __name__ == '__main__':
    from argparse import ArgumentParser

    # Parse command-line arguments to specify the port.
    parser = ArgumentParser()
    parser.add_argument('-p', '--port', default=5000, type=int, help='port to listen on')
    args = parser.parse_args()
    port = args.port

    # Run the Flask app.
    app.run(host='0.0.0.0', port=port)
