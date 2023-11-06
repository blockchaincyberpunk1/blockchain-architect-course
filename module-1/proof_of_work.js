const crypto = require('crypto');

class Block {
    constructor(index, previousHash, timestamp, data, nonce = 0) {
        // Initialize a new block with the given parameters
        this.index = index;
        this.previousHash = previousHash;
        this.timestamp = timestamp;
        this.data = data;
        this.nonce = nonce;
        this.hash = this.calculateHash(); // Calculate and set the hash
    }

    calculateHash() {
        // Calculate the hash of the block's contents using SHA-256
        const data = `${this.index}${this.previousHash}${this.timestamp}${this.data}${this.nonce}`;
        return crypto.createHash('sha256').update(data).digest('hex');
    }

    mineBlock(difficulty) {
        // Mine the block by finding a nonce that produces a hash with a prefix of zeros
        const target = '0'.repeat(difficulty);
        while (this.hash.substring(0, difficulty) !== target) {
            this.nonce++;
            this.hash = this.calculateHash();
        }
        console.log(`Block mined: ${this.hash}`);
    }
}

class Blockchain {
    constructor() {
        // Initialize the blockchain with a genesis block
        this.chain = [this.createGenesisBlock()];
        this.difficulty = 4; // Adjust the difficulty as needed
    }

    createGenesisBlock() {
        // Create the genesis block with predefined values
        return new Block(0, '0', Date.now(), 'Genesis Block');
    }

    getLatestBlock() {
        // Get the latest block in the blockchain
        return this.chain[this.chain.length - 1];
    }

    addBlock(newBlock) {
        // Add a new block to the blockchain
        newBlock.index = this.chain.length;
        newBlock.previousHash = this.getLatestBlock().hash;
        newBlock.timestamp = Date.now();
        newBlock.mineBlock(this.difficulty);
        this.chain.push(newBlock);
    }

    isChainValid() {
        // Check if the blockchain is valid by verifying hashes and previous hash links
        for (let i = 1; i < this.chain.length; i++) {
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];

            if (currentBlock.hash !== currentBlock.calculateHash()) {
                return false;
            }

            if (currentBlock.previousHash !== previousBlock.hash) {
                return false;
            }
        }
        return true;
    }
}

// Create a blockchain and add some blocks
const myBlockchain = new Blockchain();
myBlockchain.addBlock(new Block(1, '', 0, 'Transaction 1'));
myBlockchain.addBlock(new Block(2, '', 0, 'Transaction 2'));

// Display the blockchain
myBlockchain.chain.forEach((block) => {
    console.log(block);
    console.log();
});

// Check if the blockchain is valid
console.log('Is blockchain valid?', myBlockchain.isChainValid());
