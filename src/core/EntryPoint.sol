// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interfaces/UserOperation.sol";
import "../interfaces/IEntryPoint.sol";
import "./SenderCreator.sol";


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

    SenderCreator private immutable senderCreator = new SenderCreator();

    function getSenderAddress(bytes calldata initCode) public {
        revert(SenderAddressResult(senderCreator.createSender(initCode)));
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

    function _getRequiredPrefund(MemoryUserOp memory mUserOp) internal view returns (uint256 requiredPrefund){
        uint256 mul = mUserOp.paymaster != address(0) ? 3: 1;
        uint256 requiredGas = mUserOp.callGasLimit + mUserOp.verificationGasLimit * mul + mUserOp.preVerificationGas;
        requiredPrefund = requiredGas * mUserOp.maxFeePerGas;
    }

    function _createSenderIfNeeded(uint256 opIndex, UserOpInfo memory opInfo, bytes calldata initCode) internal {
        if(initCode.length != 0){
            address sender = opInfo.mUserOp.sender;
            if(sender.code.length != 0) revert FailedOp(opIndex, "sender already constructed");
            address newSender = senderCreator.createSender{gas: opInfo.mUserOp.verificationGasLimit}(initCode);
            if(newSender == address(0)) revert FailedOp(opIndex, "initCode failed or OOG");
            if(newSender != sender) revert FailedOp(opIndex, "initCode must return sender");
            if(newSender.code.length == 0) revert FailedOp(opIndex, "initCode must create sender");
            address factory = address(bytes20(initCode[0:20]));
            emit AccountDeployed(opInfo.userOpHash, sender, factory, opInfo.mUserOp.paymaster);
        }
    }
}