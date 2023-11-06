// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import Ownable and ERC721 contracts from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Define the EventTicketing contract, inheriting from ERC721 and Ownable
contract EventTicketing is ERC721, Ownable {
    // State variables to keep track of ticket-related information
    uint256 public ticketCounter;         // Counter for generating unique ticket IDs
    uint256 public maxTickets;            // Maximum number of available tickets
    uint256 public ticketPrice;           // Price of each ticket

    // Struct to represent a ticket
    struct Ticket {
        uint256 ticketId;   // Unique ticket ID
        address owner;      // Owner of the ticket
    }

    // Mapping to store tickets using their ticket ID
    mapping(uint256 => Ticket) public tickets;

    // Mapping to store the tickets owned by each user
    mapping(address => uint256[]) public userTickets;

    // Events to log ticket-related actions
    event TicketPurchased(uint256 indexed ticketId, address indexed owner);
    event TicketTransferred(uint256 indexed ticketId, address indexed from, address indexed to);

    // Constructor to initialize the contract with ticket parameters
    constructor(uint256 _maxTickets, uint256 _ticketPrice, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        maxTickets = _maxTickets;
        ticketPrice = _ticketPrice;
        ticketCounter = 1;
    }

    // Function to allow users to purchase a ticket
    function purchaseTicket() public payable {
        // Require that the sent value matches the ticket price
        require(msg.value == ticketPrice, "Incorrect ticket price");
        // Require that there are available tickets
        require(ticketCounter <= maxTickets, "No more tickets available");

        // Generate a unique ticket ID
        uint256 ticketId = ticketCounter;
        ticketCounter++;

        // Mint the ticket and assign ownership to the sender
        _mint(msg.sender, ticketId);
        tickets[ticketId] = Ticket({ ticketId: ticketId, owner: msg.sender });
        userTickets[msg.sender].push(ticketId);

        // Emit an event to log the ticket purchase
        emit TicketPurchased(ticketId, msg.sender);
    }

    // Function to allow the owner to transfer a ticket to another address
    function transferTicket(address _to, uint256 _ticketId) public {
        // Require that the sender is approved or is the owner of the ticket
        require(_isApprovedOrOwner(msg.sender, _ticketId), "Not approved or owner of the ticket");
        // Require that the sender is the current owner of the ticket
        require(ownerOf(_ticketId) == msg.sender, "Not the owner of the ticket");

        // Transfer the ticket ownership to the specified address
        _transfer(msg.sender, _to, _ticketId);
        // Update the owner of the ticket in the mapping
        tickets[_ticketId].owner = _to;
        // Remove the ticket from the sender's list of tickets and add it to the recipient's list
        userTickets[msg.sender] = _removeTicketFromUser(msg.sender, _ticketId);
        userTickets[_to].push(_ticketId);

        // Emit an event to log the ticket transfer
        emit TicketTransferred(_ticketId, msg.sender, _to);
    }

    // Function to get the list of tickets owned by a user
    function getUserTickets(address _user) public view returns (uint256[] memory) {
        return userTickets[_user];
    }

    // Internal function to remove a ticket from a user's list of tickets
    function _removeTicketFromUser(address _user, uint256 _ticketId) internal pure returns (uint256[] memory) {
        uint256[] memory userTicketsCopy = new uint256[](0);
        for (uint256 i = 0; i < userTickets[_user].length; i++) {
            if (userTickets[_user][i] != _ticketId) {
                userTicketsCopy = _addTicketToUser(userTicketsCopy, userTickets[_user][i]);
            }
        }
        return userTicketsCopy;
    }

    // Internal function to add a ticket to a user's list of tickets
    function _addTicketToUser(uint256[] memory _userTickets, uint256 _ticketId) internal pure returns (uint256[] memory) {
        uint256[] memory newTickets = new uint256[](_userTickets.length + 1);
        for (uint256 i = 0; i < _userTickets.length; i++) {
            newTickets[i] = _userTickets[i];
        }
        newTickets[_userTickets.length] = _ticketId;
        return newTickets;
    }
}
