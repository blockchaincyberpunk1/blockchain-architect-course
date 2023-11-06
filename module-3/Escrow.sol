// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    // Addresses of the parties involved
    address public payer;        // The one who funds the escrow
    address public payee;        // The intended recipient of funds
    address public arbitrator;   // The third-party to resolve disputes

    uint256 public amount;       // The amount of funds held in escrow
    bool public released;        // Indicates whether funds have been released
    bool public disputed;        // Indicates whether the contract is in dispute

    constructor(address _payee, address _arbitrator) {
        payer = msg.sender;      // Initialize the payer as the contract creator
        payee = _payee;          // Initialize the payee with the provided address
        arbitrator = _arbitrator; // Initialize the arbitrator with the provided address
        amount = 0;              // Initialize the escrow amount to zero
        released = false;        // Funds are not released by default
        disputed = false;        // No dispute by default
    }

    // Modifier to restrict function access to only the payer
    modifier onlyPayer() {
        require(msg.sender == payer, "Only the payer can call this function");
        _;
    }

    // Modifier to restrict function access to only the payee
    modifier onlyPayee() {
        require(msg.sender == payee, "Only the payee can call this function");
        _;
    }

    // Modifier to restrict function access to only the arbitrator
    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only the arbitrator can call this function");
        _;
    }

    // Modifier to require that the contract is in dispute
    modifier inDispute() {
        require(disputed, "The contract must be in dispute");
        _;
    }

    // Modifier to require that the contract is not in dispute
    modifier notDisputed() {
        require(!disputed, "The contract must not be in dispute");
        _;
    }

    // Function for the payer to deposit funds into the escrow
    function deposit() external payable onlyPayer {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        amount += msg.value;
    }

    // Function for the payee to release funds to themselves
    function releaseToPayee() external onlyPayee notDisputed {
        require(!released, "Funds have already been released");
        released = true;
        payable(payee).transfer(amount);
    }

    // Function for the payer to refund funds to themselves
    function refundToPayer() external onlyPayer notDisputed {
        require(!released, "Funds have already been released");
        released = true;
        payable(payer).transfer(amount);
    }

    // Function for the arbitrator to initiate a dispute
    function initiateDispute() external onlyArbitrator notDisputed {
        disputed = true;
    }

    // Function for the arbitrator to resolve a dispute
    function resolveDispute(bool payerWins) external onlyArbitrator inDispute {
        disputed = false;
        if (payerWins) {
            payable(payer).transfer(amount);
        } else {
            payable(payee).transfer(amount);
        }
    }
}
