const express = require("express");
const Web3 = require("web3");
const app = express();
const port = 3000;

// Initialize Web3 with your Ethereum node's RPC URL
const web3 = new Web3("https://mainnet.infura.io/v3/e8f0682204f74f9fbd1fce2f52199a64");

// Set the view engine to EJS
app.set("view engine", "ejs");

// Define a route to get block information by block number
app.get("/block/:blockNumber", async (req, res) => {
  const blockNumber = req.params.blockNumber;
  try {
    const block = await web3.eth.getBlock(blockNumber);
    res.render("block", { block });
  } catch (error) {
    res.render("error", { error });
  }
});

// Define a route to get transaction information by transaction hash
app.get("/transaction/:txHash", async (req, res) => {
  const txHash = req.params.txHash;
  try {
    const transaction = await web3.eth.getTransaction(txHash);
    res.render("transaction", { transaction });
  } catch (error) {
    res.render("error", { error });
  }
});

// Define a route to get account balance by address
app.get("/address/:address", async (req, res) => {
  const address = req.params.address;
  try {
    const balance = await web3.eth.getBalance(address);
    res.render("address", { address, balance });
  } catch (error) {
    res.render("error", { error });
  }
});

app.listen(port, () => {
  console.log(`Blockchain Explorer listening at http://localhost:${port}`);
});
