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

    function balanceOf(address account) public view returns (uint256){
        return deposits[account].deposit;
    }

    receive() external payable {
        depositTo(msg.sender);
    }

    function _incrementDeposit(address account, uint256 amount) internal {
        DepositInfo storage depositInfo = deposits[account];
        uint256 newAmount = depositInfo.deposit + amount;
        require(newAmount <= type(uint112).max, "deposit overflow");
        depositInfo.deposit = uint112(newAmount);
    }

    function depositTo(address account) public payable {
        _incrementDeposit(account, msg.value);
        DepositInfo storage depositInfo = deposits[account];
        emit Deposited(account, depositInfo.deposit);
    }

    function addStake(uint32 unstakeDelaySec) public payable {
        // *** opt
        require(unstakeDelaySec > 0, "must specify unstake delay");
        DepositInfo storage info = deposits[msg.sender];
        require(unstakeDelaySec >= info.unstakeDelaySec, "cannot decrease unstake delay");
        uint256 stake = info.stake + msg.value;
        require(stake > 0, "no stake specified");
        require(stake <= type(uint112).max, "stake overflow");
        deposits[msg.sender] = DepositInfo(
            info.deposit,
            true,
            uint112(stake),
            unstakeDelaySec,
            0
        );

        emit StakeLocked(msg.sender, stake, unstakeDelaySec);
    }
}