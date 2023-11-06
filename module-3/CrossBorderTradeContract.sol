// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import Ownable contract from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

// Define the CrossBorderTradeContract, inheriting from Ownable
contract CrossBorderTradeContract is Ownable {
    // Enum for different trade statuses
    enum TradeStatus { Created, Shipped, Delivered, Completed, Cancelled }

    // Struct to represent a trade
    struct Trade {
        uint256 tradeId;     // Unique trade ID
        address seller;     // Seller's address
        address buyer;      // Buyer's address
        uint256 price;      // Trade price
        TradeStatus status; // Current status of the trade
    }

    // Counter for generating unique trade IDs
    uint256 public tradeCounter;
    
    // Mapping to store trades using their trade ID
    mapping(uint256 => Trade) public trades;

    // Events to log trade actions
    event TradeCreated(uint256 indexed tradeId, address indexed seller, address indexed buyer, uint256 price);
    event TradeShipped(uint256 indexed tradeId);
    event TradeDelivered(uint256 indexed tradeId);
    event TradeCompleted(uint256 indexed tradeId);
    event TradeCancelled(uint256 indexed tradeId);

    // Constructor to initialize the contract
    constructor() {
        tradeCounter = 1;
    }

    // Function to create a new trade
    function createTrade(address _buyer, uint256 _price) public onlyOwner {
        // Generate a unique trade ID
        uint256 tradeId = tradeCounter;
        tradeCounter++;

        // Create a new Trade struct and store it in the trades mapping
        trades[tradeId] = Trade({
            tradeId: tradeId,
            seller: msg.sender,
            buyer: _buyer,
            price: _price,
            status: TradeStatus.Created
        });

        // Emit an event to log the creation of the trade
        emit TradeCreated(tradeId, msg.sender, _buyer, _price);
    }

    // Function to mark a trade as shipped
    function shipTrade(uint256 _tradeId) public onlyOwner {
        // Retrieve the trade from the mapping
        Trade storage trade = trades[_tradeId];

        // Ensure the trade is in the Created state
        require(trade.status == TradeStatus.Created, "Trade is not in Created state");

        // Update the trade status to Shipped
        trade.status = TradeStatus.Shipped;

        // Emit an event to log the shipment of the trade
        emit TradeShipped(_tradeId);
    }

    // Function to mark a trade as delivered
    function deliverTrade(uint256 _tradeId) public onlyOwner {
        // Retrieve the trade from the mapping
        Trade storage trade = trades[_tradeId];

        // Ensure the trade is in the Shipped state
        require(trade.status == TradeStatus.Shipped, "Trade is not in Shipped state");

        // Update the trade status to Delivered
        trade.status = TradeStatus.Delivered;

        // Emit an event to log the delivery of the trade
        emit TradeDelivered(_tradeId);
    }

    // Function to mark a trade as completed
    function completeTrade(uint256 _tradeId) public onlyOwner {
        // Retrieve the trade from the mapping
        Trade storage trade = trades[_tradeId];

        // Ensure the trade is in the Delivered state
        require(trade.status == TradeStatus.Delivered, "Trade is not in Delivered state");

        // Update the trade status to Completed
        trade.status = TradeStatus.Completed;

        // Emit an event to log the completion of the trade
        emit TradeCompleted(_tradeId);
    }

    // Function to cancel a trade
    function cancelTrade(uint256 _tradeId) public onlyOwner {
        // Retrieve the trade from the mapping
        Trade storage trade = trades[_tradeId];

        // Ensure the trade is in the Created state
        require(trade.status == TradeStatus.Created, "Trade is not in Created state");

        // Update the trade status to Cancelled
        trade.status = TradeStatus.Cancelled;

        // Emit an event to log the cancellation of the trade
        emit TradeCancelled(_tradeId);
    }
}
