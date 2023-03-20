// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./UserOperation.sol";

interface IAggregator {
    function validateSigantures(UserOperation[] calldata ops, bytes calldata signature) external view;

    function validateUserOpSignature(UserOperation calldata op, bytes calldata signature) external view returns (bytes memory sigForUserOp);

    function aggregateSignature(UserOperation[] calldata ops) external view returns (bytes memory aggregatedSignature);
}