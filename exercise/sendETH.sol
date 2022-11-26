//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
//transfer: 2300 gas,revet
//send: 2300 gas, return bool
//call： all gas, return(bool,data)

error SendFailed();//send失败
error CallFailed();//call失败

contract SendETH {
    constructor() payable{}
    receive() external payable{}

    function transferETH(address payable _to, uint256 amout) external payable{
        _to.transfer(amout);
    }
    function sendETH(address payable _to,uint256 amout) external payable{
        bool success = _to.send(amout);
        if (!success){
            revert SendFailed();
        }
    }
    function callETH(address payable _to, uint amout) external payable{
        (bool success,) = _to.call{value: amout}("");
        if(!success){
            revert CallFailed();
        }
    }
}

