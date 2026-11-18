// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "../contracts/TrustLedger.sol";

contract DeployTrustLedger {
    function run() external returns (TrustLedger) {
        TrustLedger ledger = new TrustLedger();
        return ledger;
    }
}

