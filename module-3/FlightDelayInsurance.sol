// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FlightDelayInsurance {
    address public owner; // Address of the contract owner

    // Enumeration to define policy status
    enum PolicyStatus { Active, Claimed, Expired }

    // Struct to represent an insurance policy
    struct Policy {
        string policyName;        // Name of the insurance policy
        uint256 premiumAmount;    // Amount paid as a premium for the policy
        uint256 payoutAmount;     // Amount to be paid out in case of a claim
        uint256 claimTime;        // Time when a claim can be made
        address policyHolder;     // Address of the policy holder
        PolicyStatus status;      // Status of the policy
    }

    mapping(uint256 => Policy) public policies; // Mapping to store policies by ID
    uint256 public policyCounter;                // Counter to keep track of policy IDs

    // Events to log policy-related actions
    event PolicyCreated(uint256 policyId, string policyName, uint256 premiumAmount, uint256 payoutAmount);
    event PolicyClaimed(uint256 policyId, address indexed policyHolder, uint256 payoutAmount);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Modifier to check if a policy with a given ID exists
    modifier policyExists(uint256 policyId) {
        require(policyId <= policyCounter, "Policy does not exist.");
        _;
    }

    // Modifier to check if a policy with a given ID is active
    modifier policyActive(uint256 policyId) {
        require(policies[policyId].status == PolicyStatus.Active, "Policy is not active.");
        _;
    }

    // Function to create a new insurance policy
    function createPolicy(string memory _policyName, uint256 _premiumAmount, uint256 _payoutAmount, uint256 _claimTime) public payable onlyOwner {
        policyCounter++;
        policies[policyCounter] = Policy(_policyName, _premiumAmount, _payoutAmount, _claimTime, msg.sender, PolicyStatus.Active);
        emit PolicyCreated(policyCounter, _policyName, _premiumAmount, _payoutAmount);
    }

    // Function to allow a policy holder to claim an insurance policy
    function claimPolicy(uint256 policyId) public policyExists(policyId) policyActive(policyId) {
        Policy storage policy = policies[policyId];
        require(msg.sender == policy.policyHolder, "Only the policy holder can claim.");
        require(block.timestamp >= policy.claimTime, "The claim time has not arrived yet.");

        policy.status = PolicyStatus.Claimed;
        payable(msg.sender).transfer(policy.payoutAmount);

        emit PolicyClaimed(policyId, msg.sender, policy.payoutAmount);
    }

    // Function to get the status of an insurance policy
    function policyStatus(uint256 policyId) public view returns (PolicyStatus) {
        return policies[policyId].status;
    }
}
