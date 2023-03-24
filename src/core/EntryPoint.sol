// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interfaces/UserOperation.sol";
import "../interfaces/IEntryPoint.sol";

contract EntryPoint is IEntryPoint {

    function _simulationOnlyValidation(UserOperation calldata userOp) internal view {
        try this._validateSenderAndPaymaster(userOp.initCode, userOp.sender, userOp.paymasterAndData){}
        catch Error(string memory reason){
            if(bytes(reason).length != 0){
                revert FailedOp(0, reason);
            }
        }
        
    }

    function _validateSenderAndPaymaster(bytes calldata initCode, address sender, bytes calldata paymasterAndData) external view {
        if(initCode.length == 0 && sender.code.length ==0){
            revert("Account not deployed");
        }

        if(paymasterAndData.length >= 20){
            address paymaster = address(bytes20(paymasterAndData[0:20]));
            if(paymaster.code.length == 0){
                revert("Paymaster not deployed");
            }
        }

        revert("");
    }
}