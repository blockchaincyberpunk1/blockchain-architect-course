// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HealthcareRecordSystem {
    address public owner; // Address of the contract owner

    // Struct to represent a medical record
    struct MedicalRecord {
        string patientName;   // Name of the patient associated with the record
        string medicalData;   // Medical data or information of the patient
        bool accessGranted;   // Flag indicating whether access is granted to healthcare providers
    }

    // Mapping to associate each patient's address with their medical record
    mapping(address => MedicalRecord) public medicalRecords;

    // Events to log healthcare record system actions
    event MedicalRecordCreated(address indexed patient, string patientName);
    event MedicalDataAccessGranted(address indexed patient, address indexed healthcareProvider);
    event MedicalDataAccessRevoked(address indexed patient, address indexed healthcareProvider);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Function to create a new medical record for a patient
    function createMedicalRecord(string memory _patientName) public {
        require(bytes(medicalRecords[msg.sender].patientName).length == 0, "Medical record already exists.");

        medicalRecords[msg.sender] = MedicalRecord({
            patientName: _patientName,
            medicalData: "",
            accessGranted: false
        });

        emit MedicalRecordCreated(msg.sender, _patientName);
    }

    // Function to grant access to a healthcare provider for a patient's record
    function grantAccess(address healthcareProvider) public {
        require(bytes(medicalRecords[msg.sender].patientName).length > 0, "Medical record does not exist.");
        require(!medicalRecords[msg.sender].accessGranted, "Access already granted.");

        medicalRecords[msg.sender].accessGranted = true;
        emit MedicalDataAccessGranted(msg.sender, healthcareProvider);
    }

    // Function to revoke access to a patient's record
    function revokeAccess() public {
        require(medicalRecords[msg.sender].accessGranted, "Access not granted.");

        medicalRecords[msg.sender].accessGranted = false;
        emit MedicalDataAccessRevoked(msg.sender, msg.sender);
    }

    // Function to update medical data in a patient's record
    function updateMedicalData(string memory _medicalData) public {
        require(bytes(medicalRecords[msg.sender].patientName).length > 0, "Medical record does not exist.");
        require(medicalRecords[msg.sender].accessGranted, "Access not granted.");

        medicalRecords[msg.sender].medicalData = _medicalData;
    }
}
