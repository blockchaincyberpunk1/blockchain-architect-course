// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SupplyChain {
    address public owner; // Address of the contract owner

    // Enumeration to define product status
    enum ProductStatus { Created, Shipped, Received }

    // Struct to represent a product
    struct Product {
        string name;          // Name of the product
        uint256 price;        // Price of the product
        ProductStatus status; // Status of the product
    }

    mapping(uint256 => Product) public products; // Mapping to store products by ID
    uint256 public productCounter;               // Counter to keep track of product IDs

    // Events to log actions
    event ProductCreated(uint256 productId, string name, uint256 price);
    event ProductShipped(uint256 productId);
    event ProductReceived(uint256 productId);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Modifier to check if a product with a given ID exists
    modifier productExists(uint256 productId) {
        require(productId <= productCounter, "Product does not exist.");
        _;
    }

    // Modifier to check if a product with a given ID is not yet shipped
    modifier productNotShipped(uint256 productId) {
        require(products[productId].status == ProductStatus.Created, "Product has already been shipped or received.");
        _;
    }

    // Function to create a new product
    function createProduct(string memory _name, uint256 _price) public onlyOwner {
        productCounter++;
        products[productCounter] = Product(_name, _price, ProductStatus.Created);
        emit ProductCreated(productCounter, _name, _price);
    }

    // Function to mark a product as shipped
    function shipProduct(uint256 productId) public onlyOwner productExists(productId) productNotShipped(productId) {
        products[productId].status = ProductStatus.Shipped;
        emit ProductShipped(productId);
    }

    // Function to mark a shipped product as received
    function receiveProduct(uint256 productId) public onlyOwner productExists(productId) {
        require(products[productId].status == ProductStatus.Shipped, "Product is not yet shipped.");
        products[productId].status = ProductStatus.Received;
        emit ProductReceived(productId);
    }

    // Function to get the status of a product
    function getProductStatus(uint256 productId) public view returns (ProductStatus) {
        return products[productId].status;
    }
}
