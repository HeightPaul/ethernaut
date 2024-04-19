// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendIt {
    constructor() payable  {

    }

    function sendIt(address payable _forceContract) public  {
        selfdestruct(_forceContract);
    }
}