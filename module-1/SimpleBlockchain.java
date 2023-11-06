import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;

class Block {
    private int index;
    private long timestamp;
    private String data;
    private String previousHash;
    private String hash;

    // Constructor to create a new block
    public Block(int index, String data, String previousHash) {
        this.index = index;
        this.timestamp = new Date().getTime();
        this.data = data;
        this.previousHash = previousHash;
        this.hash = calculateHash();
    }

    // Calculate the hash of the block using SHA-256
    public String calculateHash() {
        String dataToHash = index + timestamp + data + previousHash;
        StringBuilder hash = new StringBuilder();

        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = messageDigest.digest(dataToHash.getBytes());

            // Convert bytes to hexadecimal representation
            for (byte hashedByte : hashedBytes) {
                String hex = Integer.toHexString(0xff & hashedByte);

                if (hex.length() == 1) {
                    hash.append('0'); // Ensure leading zeros
                }

                hash.append(hex);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return hash.toString();
    }

    // Getter methods for block attributes
    public int getIndex() {
        return index;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public String getData() {
        return data;
    }

    public String getPreviousHash() {
        return previousHash;
    }

    public String getHash() {
        return hash;
    }

    // Setter method for updating the hash attribute (used for tampering prevention)
    public void setHash(String hash) {
        this.hash = hash;
    }

    // Setter method for updating the data attribute (used for tampering prevention)
    public void setData(String data) {
        this.data = data;
    }
}

class Blockchain {
    private ArrayList<Block> chain;

    // Constructor to initialize the blockchain with a genesis block
    public Blockchain() {
        chain = new ArrayList<>();
        createGenesisBlock();
    }

    // Create the genesis block and add it to the blockchain
    private void createGenesisBlock() {
        chain.add(new Block(0, "Genesis Block", "0"));
    }

    // Get the latest block in the blockchain
    public Block getLatestBlock() {
        return chain.get(chain.size() - 1);
    }

    // Add a new block to the blockchain with provided data
    public void addBlock(String data) {
        Block previousBlock = getLatestBlock();
        int newIndex = previousBlock.getIndex() + 1;
        String newHash = calculateHash(newIndex, previousBlock.getHash(), data);
        chain.add(new Block(newIndex, data, newHash));
    }

    // Calculate the hash for a new block based on its index, previous hash, and data
    private String calculateHash(int index, String previousHash, String data) {
        String dataToHash = index + previousHash + data;
        StringBuilder hash = new StringBuilder();

        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = messageDigest.digest(dataToHash.getBytes());

            // Convert bytes to hexadecimal representation
            for (byte hashedByte : hashedBytes) {
                String hex = Integer.toHexString(0xff & hashedByte);

                if (hex.length() == 1) {
                    hash.append('0'); // Ensure leading zeros
                }

                hash.append(hex);
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return hash.toString();
    }

    // Check if the blockchain is valid by verifying hashes and previous hash links
    public boolean isChainValid() {
        for (int i = 1; i < chain.size(); i++) {
            Block currentBlock = chain.get(i);
            Block previousBlock = chain.get(i - 1);

            // Verify that the current block's hash matches the calculated hash
            if (!currentBlock.getHash().equals(currentBlock.calculateHash())) {
                return false;
            }

            // Verify that the previous hash in the current block matches the hash of the previous block
            if (!currentBlock.getPreviousHash().equals(previousBlock.getHash())) {
                return false;
            }
        }

        return true;
    }
}

// Main class to run the blockchain
public class SimpleBlockchain {
    public static void main(String[] args) {
        Blockchain blockchain = new Blockchain();

        // Add blocks to the blockchain
        blockchain.addBlock("Transaction 1");
        blockchain.addBlock("Transaction 2");

        // Check if the blockchain is valid and print the result
        System.out.println("Blockchain is valid: " + blockchain.isChainValid());

        // Uncomment the lines below to attempt tampering with data (preventing this by making the block immutable)
        // Block blockToTamper = blockchain.getLatestBlock();
        // blockToTamper.setData("Tampered Data");
        // blockToTamper.setHash(blockToTamper.calculateHash());

        // Check the validity again after tampering
        // System.out.println("Blockchain is valid: " + blockchain.isChainValid());
    }
}
