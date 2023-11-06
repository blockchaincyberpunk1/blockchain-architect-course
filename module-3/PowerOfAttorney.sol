// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PowerOfAttorney {
    address public owner; // Address of the contract owner

    // Enumeration to define agreement status
    enum AgreementStatus { Created, Executed, Cancelled }

    // Struct to represent a power of attorney agreement
    struct Agreement {
        string agreementTitle;  // Title or name of the agreement
        string agreementText;   // Text or content of the agreement
        address grantor;        // Address of the grantor (the person granting power)
        address attorney;       // Address of the attorney (the person receiving power)
        uint256 expirationDate; // Date when the power of attorney expires
        AgreementStatus status; // Status of the agreement
    }

    mapping(uint256 => Agreement) public agreements; // Mapping to store agreements by ID
    uint256 public agreementCounter;                // Counter to keep track of agreement IDs

    // Events to log agreement-related actions
    event AgreementCreated(uint256 agreementId, string agreementTitle, address grantor, address attorney, uint256 expirationDate);
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

    // Function to create a new power of attorney agreement
    function createAgreement(
        string memory _agreementTitle,
        string memory _agreementText,
        address _attorney,
        uint256 _expirationDate
    ) public onlyOwner {
        agreementCounter++;
        agreements[agreementCounter] = Agreement(
            _agreementTitle,
            _agreementText,
            msg.sender,
            _attorney,
            _expirationDate,
            AgreementStatus.Created
        );
        emit AgreementCreated(agreementCounter, _agreementTitle, msg.sender, _attorney, _expirationDate);
    }

    // Function to allow the attorney to execute a power of attorney agreement
    function executeAgreement(uint256 agreementId) public agreementExists(agreementId) agreementCreated(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(msg.sender == agreement.attorney, "Only the attorney can execute the agreement.");
        require(block.timestamp <= agreement.expirationDate, "Power of Attorney has expired.");

        agreement.status = AgreementStatus.Executed;
        emit AgreementExecuted(agreementId);
    }

    // Function to allow the grantor to cancel a power of attorney agreement
    function cancelAgreement(uint256 agreementId) public agreementExists(agreementId) agreementCreated(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        require(msg.sender == agreement.grantor, "Only the grantor can cancel the agreement.");

        agreement.status = AgreementStatus.Cancelled;
        emit AgreementCancelled(agreementId);
    }

    // Function to get the status of a power of attorney agreement
    function getAgreementStatus(uint256 agreementId) public view returns (AgreementStatus) {
        return agreements[agreementId].status;
    }
}
