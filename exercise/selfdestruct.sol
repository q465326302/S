//SPDX-License-Identifer:MIT
pragma solidity ^0.8.4;
contract DeleteContract {
    uint public value = 10;
    constructor() payable {}
    receive() external payable {}
    function deletecontract() external{
        selfdestruct(payable(msg.sender));
    }
    function getBalance() external view returns(uint balance){
        balance = address(this).balance;
    }
}