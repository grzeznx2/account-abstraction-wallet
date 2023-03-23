// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interfaces/UserOperation.sol";
import "../interfaces/IAccount.sol";
import "../interfaces/IEntryPoint.sol";

abstract contract BaseAccount is IAccount {
    function nonce() public virtual view returns (uint256);

    function entryPoint() public virtual view returns (IEntryPoint);

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash) internal virtual returns (uint256 validationData);

    function _validateAndUpdateNonce(UserOperation calldata userOp) internal virtual;
}
