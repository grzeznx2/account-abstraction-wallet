// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interfaces/UserOperation.sol";
import "../interfaces/IEntryPoint.sol";

contract EntryPoint is IEntryPoint {

    struct MemoryUserOp {
        address sender;
        uint256 nonce;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        address paymaster;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
    }

    struct UserOpInfo {
        MemoryUserOp mUserOp;
        bytes32 userOpHash;
        uint256 prefund;
        uint256 contextOffset;
        uint256 preOpGas;
    }

    function _simulationOnlyValidations(UserOperation calldata userOp) internal view {
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