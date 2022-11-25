//SPDX-License-Identifier:MIF
pragma solidity ^0.8.4;
contract Receive{
    event receivedCalled(address Sender ,uint Value);
    event fallbackCalled(address Sender,uint Value,bytes Dota);
    receive()external payable {
        emit receivedCalled(msg.sender,msg.value);
    }
    fallback() external payable{
        emit fallbackCalled(msg.sender,msg.value, msg.data);
    }
}