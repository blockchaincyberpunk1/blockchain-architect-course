// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LegalAgreement {
    address public owner; // Address of the contract owner

    // Enumeration to define agreement status
    enum AgreementStatus { Created, Executed, Cancelled }

    // Struct to represent a legal agreement
    struct Agreement {
        string agreementTitle; // Title or name of the agreement
        string agreementText;  // Text or content of the agreement
        address party1;        // Address of the first party
        address party2;        // Address of the second party
        AgreementStatus status; // Status of the agreement
    }

    mapping(uint256 => Agreement) public agreements; // Mapping to store agreements by ID
    uint256 public agreementCounter;                // Counter to keep track of agreement IDs

    // Events to log agreement-related actions
    event AgreementCreated(uint256 agreementId, string agreementTitle, address party1, address party2);
    event AgreementExecuted(uint256 agreementId);
    event AgreementCancelled(uint256 agreementId);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Modifier to check if an agreement with a given ID exists
    modifier agreementExists(uint256 agreementId) {
        require(agreementId <= agreementCounter, "Agreement does not exist.");
        _;
    }

    // Modifier to check if an agreement with a given ID is in the "Created" state
    modifier agreementCreated(uint256 agreementId) {
        require(agreements[agreementId].status == AgreementStatus.Created, "Agreement is not in a created state.");
        _;
    }

    // Function to create a new legal agreement
    function createAgreement(string memory _agreementTitle, string memory _agreementText, address _party2) public onlyOwner {
        agreementCounter++;
        agreements[agreementCounter] = Agreement(_agreementTitle, _agreementText, msg.sender, _party2, AgreementStatus.Created);
        emit AgreementCreated(agreementCounter, _agreementTitle, msg.sender, _party2);
    }

    // Function to allow involved parties to execute a legal agreement
    function executeAgreement(uint256 agreementId) public agreementExists(agreementId) agreementCreated(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(msg.sender == agreement.party1 || msg.sender == agreement.party2, "Only involved parties can execute the agreement.");

        agreement.status = AgreementStatus.Executed;
        emit AgreementExecuted(agreementId);
    }

    // Function to allow involved parties to cancel a legal agreement
    function cancelAgreement(uint256 agreementId) public agreementExists(agreementId) agreementCreated(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(msg.sender == agreement.party1 || msg.sender == agreement.party2, "Only involved parties can cancel the agreement.");

        agreement.status = AgreementStatus.Cancelled;
        emit AgreementCancelled(agreementId);
    }

    // Function to get the status of a legal agreement
    function getAgreementStatus(uint256 agreementId) public view returns (AgreementStatus) {
        return agreements[agreementId].status;
    }
}
