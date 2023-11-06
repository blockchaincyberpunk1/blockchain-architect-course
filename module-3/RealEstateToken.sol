// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import OpenZeppelin ERC721 and Ownable contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Define the RealEstateToken contract, inheriting from ERC721 and Ownable
contract RealEstateToken is ERC721, Ownable {
    // Declare state variables
    uint256 public tokenIdCounter;             // Counter for token IDs
    uint256 public totalTokens;                // Total number of tokens minted
    string public baseTokenURI;                // Base URI for token metadata

    // Mapping to associate token IDs with property IDs
    mapping(uint256 => uint256) public tokenToPropertyId;
    // Mapping to associate property IDs with token IDs
    mapping(uint256 => uint256) public propertyIdToToken;

    // Event emitted when a RealEstateToken is minted
    event RealEstateTokenMinted(uint256 indexed tokenId, uint256 indexed propertyId, address indexed owner);

    // Constructor to initialize the contract
    constructor(string memory _name, string memory _symbol, string memory _tokenURI) ERC721(_name, _symbol) {
        baseTokenURI = _tokenURI;
        tokenIdCounter = 1;
    }

    // Function to set the base token URI, only callable by the owner
    function setBaseTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    // Function to mint a RealEstateToken associated with a property
    function mintRealEstateToken(uint256 _propertyId) public onlyOwner {
        // Ensure the property is not already tokenized
        require(propertyIdToToken[_propertyId] == 0, "Property already tokenized.");
        
        // Increment the tokenIdCounter to get the next available token ID
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;

        // Mint the token and assign it to the owner
        _mint(msg.sender, tokenId);
        
        // Associate the token ID with the property ID
        tokenToPropertyId[tokenId] = _propertyId;
        
        // Associate the property ID with the token ID
        propertyIdToToken[_propertyId] = tokenId;
        
        // Increment the totalTokens count
        totalTokens++;

        // Emit an event to indicate the successful minting of the token
        emit RealEstateTokenMinted(tokenId, _propertyId, msg.sender);
    }

    // Function to get the token URI for a given token ID
    function getTokenURI(uint256 _tokenId) public view override returns (string memory) {
        // Ensure that the token exists
        require(_exists(_tokenId), "Token does not exist");
        
        // Concatenate the base token URI with the token ID as a string
        return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId)));
    }
}
