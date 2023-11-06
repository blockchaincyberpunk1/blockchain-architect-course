import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;

class Block {
    private int index;
    private String previousHash;
    private long timestamp;
    private String data;
    private int nonce;
    private String hash;

    // Constructor for creating a new block
    public Block(int index, String previousHash, String data) {
        this.index = index;
        this.previousHash = previousHash;
        this.data = data;
        this.timestamp = new Date().getTime();
        this.nonce = 0;
        this.hash = calculateHash();
    }

    // Method to calculate the hash of the block
    public String calculateHash() {
        String dataToHash = index + previousHash + timestamp + data + nonce;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(dataToHash.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte hashByte : hashBytes) {
                String hex = Integer.toHexString(0xff & hashByte);
                if (hex.length() == 1)
                    hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    // Method to mine the block with a given difficulty
    public void mineBlock(int difficulty) {
        String target = new String(new char[difficulty]).replace('\0', '0');
        while (!hash.substring(0, difficulty).equals(target)) {
            nonce++;
            hash = calculateHash();
        }
        System.out.println("Block mined: " + hash);
    }

    // Public getter methods for private variables
    public int getIndex() {
        return index;
    }

    public String getHash() {
        return hash;
    }

    public String getPreviousHash() {
        return previousHash;
    }
}

class Blockchain {
    private int difficulty;
    private ArrayList<Block> chain;

    // Constructor for creating a new blockchain with a specified difficulty
    public Blockchain(int difficulty) {
        this.difficulty = difficulty;
        this.chain = new ArrayList<>();
        chain.add(new Block(0, "0", "Genesis Block"));
    }

    // Method to add a new block to the blockchain
    public void addBlock(Block block) {
        block.mineBlock(difficulty);
        chain.add(block);
    }

    // Method to check if the blockchain is valid
    public boolean isChainValid() {
        for (int i = 1; i < chain.size(); i++) {
            Block currentBlock = chain.get(i);
            Block previousBlock = chain.get(i - 1);
            if (!currentBlock.getHash().equals(currentBlock.calculateHash())) {
                System.out.println("Block " + currentBlock.getIndex() + " has been tampered with.");
                return false;
            }
            if (!currentBlock.getPreviousHash().equals(previousBlock.getHash())) {
                System.out.println("Block " + currentBlock.getIndex() + " has an invalid previous hash.");
                return false;
            }
        }
        return true;
    }

    // Public method to access the chain
    public ArrayList<Block> getChain() {
        return chain;
    }
}

public class ProofOfWork {
    public static void main(String[] args) {
        int difficulty = 4;
        Blockchain blockchain = new Blockchain(difficulty);

        System.out.println("Mining block 1...");
        blockchain.addBlock(new Block(1, blockchain.getChain().get(blockchain.getChain().size() - 1).getHash(), "Transaction 1"));

        System.out.println("Mining block 2...");
        blockchain.addBlock(new Block(2, blockchain.getChain().get(blockchain.getChain().size() - 1).getHash(), "Transaction 2"));

        System.out.println("Is blockchain valid? " + blockchain.isChainValid());
    }
}
