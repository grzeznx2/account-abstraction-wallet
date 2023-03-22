// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./UserOperation.sol";

interface IPaymaster {
    enum PostOpMode {
        opSucceeded,
        opReverted,
        postOpReverted
    }

    function validatePaymasterUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 maxCost) 
        external returns (bytes memory context, uint256 actualGasCost);

    function postOp(PostOpMode mode, bytes calldata context, uint256 actualGasCost) external;
}