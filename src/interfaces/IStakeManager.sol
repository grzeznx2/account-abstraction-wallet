// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IStakeManager {
    event Deposited (
        address indexed account,
        uint256 totalDeposit
    );

    event Withdrawn (
        address indexed account,
        address withdrawAddress,
        uint256 amount
    );

    event StakeLocked (
        address indexed account,
        uint256 totalDeposited,
        uint256 unstakeDelaySec
    );

    event StakeUnlocked (
        address indexed account,
        uint256 withdrawTime
    )

    event StakeWithdrawn (
        address indexed account,
        address withdrawAddress,
        uint256 amount
    )
}