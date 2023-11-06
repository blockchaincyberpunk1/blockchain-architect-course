// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RealEstateContract {
    address public owner; // Address of the contract owner

    // Enumeration to define property status
    enum PropertyStatus { Listed, Sold, Closed }

    // Struct to represent a property
    struct Property {
        string name;             // Name of the property
        uint256 price;           // Price of the property
        address payable seller;  // Address of the seller
        address payable buyer;   // Address of the buyer (if sold)
        PropertyStatus status;   // Status of the property
    }

    mapping(uint256 => Property) public properties; // Mapping to store properties by ID
    uint256 public propertyCounter;                // Counter to keep track of property IDs

    // Events to log property-related actions
    event PropertyListed(uint256 propertyId, string name, uint256 price);
    event PropertySold(uint256 propertyId, address indexed seller, address indexed buyer, uint256 price);
    event PropertyClosed(uint256 propertyId, address indexed seller, uint256 price);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Modifier to check if a property with a given ID exists
    modifier propertyExists(uint256 propertyId) {
        require(propertyId <= propertyCounter, "Property does not exist.");
        _;
    }

    // Modifier to check if a property with a given ID is not yet sold
    modifier propertyNotSold(uint256 propertyId) {
        require(properties[propertyId].status == PropertyStatus.Listed, "Property has already been sold or closed.");
        _;
    }

    // Function to list a new property for sale
    function listProperty(string memory _name, uint256 _price) public onlyOwner {
        propertyCounter++;
        properties[propertyCounter] = Property(_name, _price, payable(msg.sender), payable(address(0)), PropertyStatus.Listed);
        emit PropertyListed(propertyCounter, _name, _price);
    }

    // Function to buy a listed property
    function buyProperty(uint256 propertyId) public payable propertyExists(propertyId) propertyNotSold(propertyId) {
        Property storage property = properties[propertyId];
        require(msg.value == property.price, "Incorrect payment amount.");

        property.buyer = payable(msg.sender);
        property.status = PropertyStatus.Sold;
        property.seller.transfer(msg.value);

        emit PropertySold(propertyId, property.seller, msg.sender, property.price);
    }

    // Function to close a sold property
    function closeProperty(uint256 propertyId) public onlyOwner propertyExists(propertyId) {
        Property storage property = properties[propertyId];
        require(property.status == PropertyStatus.Sold, "Property must be sold to close it.");

        property.status = PropertyStatus.Closed;
        emit PropertyClosed(propertyId, property.seller, property.price);
    }
}
