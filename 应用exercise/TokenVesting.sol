//SPDX-License-Identifier:MIT
//wtf.academy
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract TokenVesting {
    event ERC20Released(address indexed token,uint256 amount);
    //提币事件
    mapping(address => uint256) public erc20Released;
    //代币地址->释放数量的映射，记录受益人已领取的代币数量

    address public immutable beneficiary;
    //受益人地址
    uint256 public immutable start;
    //归属期 起始时间戳
    uint256 public immutable duration;
    //归属期 秒

    constructor(//初始化受益人地址、释放周期（秒）、起始时间戳（当前区块链时间戳）
        address beneficiaryAddress,
        uint256 durationSeconds
        
    ){
        require(beneficiaryAddress != address(0),"VestingWallet: beneficiary is zero address");
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }
    function release(address token) public {//受益人提取已释放的代币
        uint256 releasable = vestedAmout(token,uint256(block.timestamp)) - erc20Released[token];
        erc20Released[token] += releasable;
        emit ERC20Released(token,releasable);
        IERC20(token).transfer(beneficiary,releasable);
    }
    function vestedAmout(address token, uint256 timestamp ) public view returns (uint256) {
        //线性释放公式 根据线性释放公式，计算已经释放的数量。开发者可以通过修改这个函数，自定义释放方式
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) + erc20Released[token];
        // 合约里总共收到了多少代币（当前余额 + 已经提取）
        if (timestamp < start){
            return 0;
        } else if (timestamp > start + duration) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start)) / duration;
        }
        // 根据线性释放公式，计算已经释放的数量
    }
    
}

