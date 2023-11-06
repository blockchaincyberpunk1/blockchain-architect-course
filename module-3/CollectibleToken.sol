// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CollectibleToken is ERC721, Ownable {
    uint256 public tokenIdCounter; // Counter for generating unique token IDs
    uint256 public totalTokens; // Total number of tokens created
    string public baseTokenURI; // Base URI for metadata of tokens

    mapping(uint256 => uint256) public tokenToAssetId; // Mapping from token ID to asset ID
    mapping(uint256 => uint256) public assetIdToToken; // Mapping from asset ID to token ID

    event CollectibleMinted(uint256 indexed tokenId, uint256 indexed assetId, address indexed owner);

    // Constructor to initialize the contract
    constructor(string memory _name, string memory _symbol, string memory _tokenURI) ERC721(_name, _symbol) {
        baseTokenURI = _tokenURI;
        tokenIdCounter = 1; // Initialize the token ID counter
    }

    // Function to set the base token URI for metadata
    function setBaseTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    // Function to mint a new collectible token
    function mintCollectible(uint256 _assetId) public onlyOwner {
        require(assetIdToToken[_assetId] == 0, "Asset already tokenized."); // Ensure the asset is not already tokenized
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;

        _mint(msg.sender, tokenId); // Mint a new token and assign it to the owner
        tokenToAssetId[tokenId] = _assetId; // Map the token ID to the asset ID
        assetIdToToken[_assetId] = tokenId; // Map the asset ID to the token ID
        totalTokens++; // Increment the total token count

        emit CollectibleMinted(tokenId, _assetId, msg.sender); // Emit an event to indicate a new collectible has been minted
    }

    // Function to get the token URI for a given token ID
    function getTokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist"); // Ensure the token exists
        return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId))); // Concatenate the base URI and token ID to get the full URI
    }
}
