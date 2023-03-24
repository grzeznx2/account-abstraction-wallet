// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interfaces/IStakeManager.sol";

contract StakeManager is IStakeManager {
    // paymaster => DepositInfo
    mapping(address => DepositInfo) public deposits;

    function getDepositInfo(address account) public view returns (DepositInfo memory info){
        return deposits[account];
    }

    function _getStakeInfo(address account) internal view returns (StakeInfo memory info){
        DepositInfo storage depositInfo = deposits[account];
        info.stake = depositInfo.stake;
        info.unstakeDelaySec = depositInfo.unstakeDelaySec;
    }
}