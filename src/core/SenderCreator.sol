// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SenderCreator {
    function createSender(bytes calldata initCode) external returns (address sender){
        address factory = address(bytes20(initCode[0:20]));
        bytes memory initCallData = initCode[20:];
        bool success;

        assembly {
            success := call(
                gas(),
                factory,
                0,
                add(initCallData, 0x20),
                mload(initCallData),
                0,
                32
            )
            sender := mload(0)
        }

        if(!success){
            sender = address(0);
        }
    }
}