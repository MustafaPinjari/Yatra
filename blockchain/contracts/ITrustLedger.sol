// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

interface ITrustLedger {
    enum RecordType {
        ACCESSIBILITY_INSPECTION,
        INCIDENT_RESOLUTION,
        COMPLIANCE_CERTIFICATION
    }

    struct Record {
        bytes32 recordHash;
        RecordType recordType;
        address recorder;
        uint256 blockTimestamp;
        string entityIdentifier;
    }

    event RecordAnchored(
        bytes32 indexed recordHash,
        RecordType indexed recordType,
        address indexed recorder,
        uint256 blockTimestamp,
        string entityIdentifier
    );

    function recordVerification(
        bytes32 recordHash,
        RecordType recordType,
        string calldata entityIdentifier
    ) external;

    function verifyRecord(bytes32 recordHash)
        external
        view
        returns (
            bool isVerified,
            RecordType recordType,
            address recorder,
            uint256 blockTimestamp,
            string memory entityIdentifier
        );
}

