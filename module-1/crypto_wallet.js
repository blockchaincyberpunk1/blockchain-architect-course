const crypto = require('crypto');

// Define a Transaction class to represent transactions in the blockchain.
class Transaction {
    constructor(sender, recipient, amount) {
        this.sender = sender;         // Address of the sender
        this.recipient = recipient;   // Address of the recipient
        this.amount = amount;         // Amount being transferred
    }
}

// Define a Block class to represent blocks in the blockchain.
class Block {
    constructor(transactions, previousHash = '') {
        this.transactions = transactions;     // List of transactions in the block
        this.previousHash = previousHash;     // Hash of the previous block
        this.timestamp = Date.now();         // Timestamp of when the block is created
        this.hash = this.calculateHash();     // Current block's hash
    }

    // Calculate the hash of the block based on its data.
    calculateHash() {
        const data = this.previousHash + this.timestamp + JSON.stringify(this.transactions);
        return crypto.createHash('sha256').update(data).digest('hex');
    }

    // Mine the block by repeatedly calculating the hash until it meets the difficulty criteria.
    mineBlock(difficulty) {
        const target = '0'.repeat(difficulty);
        while (this.hash.substring(0, difficulty) !== target) {
            this.timestamp = Date.now();   // Update timestamp to change hash
            this.hash = this.calculateHash();
        }
    }
}

// Define a Blockchain class to manage the blockchain.
class Blockchain {
    constructor() {
        this.chain = [this.createGenesisBlock()];    // Initialize the chain with the genesis block
        this.pendingTransactions = [];               // List of pending transactions
        this.miningReward = 100;                     // Reward for miners
        this.difficulty = 4;                        // Difficulty for mining (adjust as needed)
    }

    // Create the genesis block (the first block in the blockchain).
    createGenesisBlock() {
        return new Block([], '0');
    }

    // Get the latest block in the blockchain.
    getLatestBlock() {
        return this.chain[this.chain.length - 1];
    }

    // Create a new transaction and add it to the list of pending transactions.
    createTransaction(sender, recipient, amount) {
        const transaction = new Transaction(sender, recipient, amount);
        this.pendingTransactions.push(transaction);
    }

    // Mine pending transactions and add a new block to the blockchain as a reward for miners.
    minePendingTransactions(miningRewardAddress) {
        const rewardTransaction = new Transaction(null, miningRewardAddress, this.miningReward);
        this.pendingTransactions.push(rewardTransaction);

        const newBlock = new Block(this.pendingTransactions, this.getLatestBlock().hash);
        newBlock.mineBlock(this.difficulty);

        this.chain.push(newBlock);
        this.pendingTransactions = [];
    }

    // Get the balance of a wallet address by calculating the net amount of transactions.
    getBalance(address) {
        let balance = 0;

        for (const block of this.chain) {
            for (const transaction of block.transactions) {
                if (transaction.sender === address) {
                    balance -= transaction.amount;
                }
                if (transaction.recipient === address) {
                    balance += transaction.amount;
                }
            }
        }

        return balance;
    }

    // Check if the blockchain is valid by verifying hashes and previous block references.
    isChainValid() {
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

// Usage example:
const myBlockchain = new Blockchain();
const myWalletAddress = 'my-wallet-address';

// Create and add transactions to the pending transactions list.
myBlockchain.createTransaction('genesis-address', myWalletAddress, 1000);
myBlockchain.createTransaction(myWalletAddress, 'recipient-address', 200);

// Mine pending transactions to create a new block.
myBlockchain.minePendingTransactions(myWalletAddress);

// Display wallet balance and check blockchain validity.
console.log(`My wallet balance: ${myBlockchain.getBalance(myWalletAddress)}`);
console.log(`Is blockchain valid? ${myBlockchain.isChainValid()}`);
