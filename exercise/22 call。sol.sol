//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract OtherContract {
    uint256 private _x = 0;
    event Log(uint amount, uint gas);
    //没有实际代码
    //
    fallback() external payable{}

    function getBalance() view public returns(uint){
        return address(this).balance;
    }
    function setX(uint256 x) external payable{
        _x = x;
        if(msg.value > 0 ) {
            emit Log(msg.value, gasleft());
            
        }
    }
    function getX() external view returns(uint x){
        x = _x;
    }

}

contract call{
    //该事件
    event Response(bool success,bytes data);
    //调用目标合约setx转入msg。value的eth 释放事件
    function callsetX(address _addr,uint256 x)public payable {
        (bool success,bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)",x)
        );
    }
    //调用get函数
    //调用——addr地址的合约getx函数 返回函数执行结果
    function callgetX(address _addr) external returns(uint256){
        (bool success,bytes memory data) = _addr.call(
            abi.encodeWithSignature("get()")
        );
        emit Response(success,data);
        return abi.decode(data,(uint256));
    }
    //调用不存在函数会触发fallback 
    function callNO(address _addr) external{
        (bool success,bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );
        emit Response(success,data);
    }
}