//SPDX-License-identifier:MIT
pragma solidity ^0.8.4;
//目标合约地址.call(二进制编码);
contract OtherContract {
    uint256 private _x = 0;
    event Log(uint amount, uint gas);
    fallback() external payable{}
    function getBalance() view public returns(uint){
        return address(this).balance;
    }
    function setX(uint256 x) external payable{
        _x = x;
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }
    function getX() external view returns(uint x){
        x = _x;
    }

}