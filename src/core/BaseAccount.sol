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

    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
        external override virtual returns(uint256 validationData){
            _requireFromEntryPoint();
            validationData = _validateSignature(userOp, userOpHash);
            if(userOp.initCode.length == 0){
                _validateAndUpdateNonce(userOp);
            }
            _payPrefund(missingAccountFunds);
        }

    function _requireFromEntryPoint() internal virtual view {
        require(msg.sender == address(entryPoint()), "account: not from EntryPoint");
    }

    function _payPrefund(uint256 missingAccountFunds) internal {
        if(missingAccountFunds != 0){
            (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        }
    }
}
