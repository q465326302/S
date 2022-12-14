// SPDX-License-Identifier: MIT
// wtf.academy
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ERC20.sol";

contract TokenLocker {
    event TokenLockStar(address indexed beneficiary,address indexed token,uint256 startTime, uint256 lockTime);
    event Release(address indexed beneficiary, address indexed token,uint256 releaseTime, uint256 amount);

    IERC20 public immutable token;//锁仓代币地址
    address public immutable beneficiary;//受益人地址
    uint256 public immutable lockTime;//锁仓时间（秒
    uint256 public immutable startTime;//锁仓起始时间戳（秒

    constructor(
        IERC20 _token,
        address _beneficiary,
        uint256 _lockTime
    ) {//初始化代币地址，受益人地址和锁仓时间
        require(_lockTime > 0, "TokenLock: lock time shoule greater than 0");
        token = _token;
        beneficiary = _beneficiary;
        lockTime = _lockTime;
        startTime = block.timestamp;

        emit TokenLockStar(_beneficiary,address(_token),block.timestamp, _lockTime);
    }
    function release() public {//锁仓后发
        require(block.timestamp >= startTime + lockTime, "TokenLock: current time is before release time");

        uint256 amount = token.balanceOf(address(this));
        require(amount > 0,"TokenLock: no tokens to release");
        token.transfer(beneficiary,amount);
        
        emit Release(msg.sender, address(token),block.timestamp, amount);
    }
}