// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "contracts/ITrustLedger.sol";

/**
 * @title TrustLedger
 * @notice Anchors cryptographic SHA-256 fingerprints of depot accessibility inspections
 *         and incident resolutions on Ethereum Sepolia testnet.
 * @dev Strict privacy rule: Zero personal identifying information (PII), GPS coordinates,
 *      or photos are stored on-chain.
 */
contract TrustLedger is ITrustLedger {
    address public owner;

    bytes32 public constant INSPECTOR_ROLE = keccak256("INSPECTOR_ROLE");
    bytes32 public constant RESOLVER_ROLE = keccak256("RESOLVER_ROLE");

    mapping(bytes32 => Record) private _records;
    mapping(address => mapping(bytes32 => bool)) private _roles;

    modifier onlyOwner() {
        require(msg.sender == owner, "TrustLedger: Caller is not owner");
        _;
    }

    modifier onlyRole(bytes32 role) {
        require(
            _roles[msg.sender][role] || msg.sender == owner,
            "TrustLedger: Unauthorized role"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
        _roles[msg.sender][INSPECTOR_ROLE] = true;
        _roles[msg.sender][RESOLVER_ROLE] = true;
    }

    function grantRole(address account, bytes32 role) external onlyOwner {
        _roles[account][role] = true;
    }

    function revokeRole(address account, bytes32 role) external onlyOwner {
        _roles[account][role] = false;
    }

    function recordVerification(
        bytes32 recordHash,
        RecordType recordType,
        string calldata entityIdentifier
    ) external override {
        require(recordHash != bytes32(0), "TrustLedger: Invalid empty hash");
        require(
            _records[recordHash].blockTimestamp == 0,
            "TrustLedger: Record already anchored"
        );

        if (recordType == RecordType.ACCESSIBILITY_INSPECTION) {
            require(
                _roles[msg.sender][INSPECTOR_ROLE] || msg.sender == owner,
                "TrustLedger: Requires inspector role"
            );
        } else if (recordType == RecordType.INCIDENT_RESOLUTION) {
            require(
                _roles[msg.sender][RESOLVER_ROLE] || msg.sender == owner,
                "TrustLedger: Requires resolver role"
            );
        }

        Record memory newRecord = Record({
            recordHash: recordHash,
            recordType: recordType,
            recorder: msg.sender,
            blockTimestamp: block.timestamp,
            entityIdentifier: entityIdentifier
        });

        _records[recordHash] = newRecord;

        emit RecordAnchored(
            recordHash,
            recordType,
            msg.sender,
            block.timestamp,
            entityIdentifier
        );
    }

    function verifyRecord(bytes32 recordHash)
        external
        view
        override
        returns (
            bool isVerified,
            RecordType recordType,
            address recorder,
            uint256 blockTimestamp,
            string memory entityIdentifier
        )
    {
        Record memory rec = _records[recordHash];
        if (rec.blockTimestamp == 0) {
            return (false, RecordType.ACCESSIBILITY_INSPECTION, address(0), 0, "");
        }
        return (
            true,
            rec.recordType,
            rec.recorder,
            rec.blockTimestamp,
            rec.entityIdentifier
        );
    }
}

