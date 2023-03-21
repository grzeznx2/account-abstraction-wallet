// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./UserOperation.sol";

interface IAccount {
    function validateUserOp (UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds) external returns (uint256 validationData);
}