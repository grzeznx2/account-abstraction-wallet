// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./UserOperation.sol";
import "./IAggregator.sol";

interface IEntryPoint {

    struct UserOpsPerAggregator {
        IAggregator aggregator;
        UserOperation[] ops;
        bytes signature;
    }

    struct ReturnInfo {
        uint256 preOpGas;
        uint256 prefund;
        bool sigFailed;
        uint48 validAfter;
        uint48 validUntil;
        bytes paymasterContext;
    }

    struct StakeInfo {
        uint256 stake;
        uint256 unstakeDelaySec;
    }

    struct AggregatorStakeInfo {
        address actualAggregator;
        StakeInfo stakeInfo;
    }

    event AccountDeployed(bytes32 indexed userOpHash, address indexed sender, address factory, address paymaster);

    error SenderAddressResult(address sender);

    error ValidationResult(ReturnInfo returnInfo, StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo);

    error ValidationResultWithAggregation(ReturnInfo returnInfo, StakeInfo senderInfo, StakeInfo factoryInfo, StakeInfo paymasterInfo, AggregatorStakeInfo aggregatorInfo);

    error FailedOp(uint256 opIndex, string reason);

    function handleOps(UserOperation[] calldata ops, address payable beneficiary) external;

    function handleAggregatedOps(UserOpsPerAggregator[] calldata opsPerAggregator, address payable beneficiary) external;

    function simulateValidation(UserOperation calldata op) external;


}