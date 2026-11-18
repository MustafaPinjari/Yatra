// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "contracts/TrustLedger.sol";
import "contracts/ITrustLedger.sol";

contract TrustLedgerTest {
    TrustLedger public ledger;
    address public inspector = address(0x1111);
    address public commuter = address(0x2222);

    function setUp() public {
        ledger = new TrustLedger();
        ledger.grantRole(inspector, ledger.INSPECTOR_ROLE());
    }

    function testAnchorAndVerifyRecord() public {
        bytes32 sampleHash = keccak256(abi.encodePacked("DEPOT_INSPECTION_DL1PD1234_20261118"));
        
        ledger.recordVerification(
            sampleHash,
            ITrustLedger.RecordType.ACCESSIBILITY_INSPECTION,
            "DL1PD1234-INSP-01"
        );

        (
            bool isVerified,
            ITrustLedger.RecordType rType,
            address recorder,
            uint256 timestamp,
            string memory entityId
        ) = ledger.verifyRecord(sampleHash);

        require(isVerified == true, "Record should be verified");
        require(rType == ITrustLedger.RecordType.ACCESSIBILITY_INSPECTION, "Type mismatch");
        require(recorder == address(this), "Recorder should be caller");
        require(timestamp > 0, "Timestamp should be positive");
        require(bytes(entityId).length > 0, "Identifier should not be empty");
    }

    function testUnrecordedHashReturnsFalse() public view {
        bytes32 unrecorded = keccak256("UNKNOWN_RECORD");
        (bool isVerified,,,,) = ledger.verifyRecord(unrecorded);
        require(isVerified == false, "Unrecorded hash must return false");
    }
}
