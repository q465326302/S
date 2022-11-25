//SPDX-License-Identifier:MIF
pragma solidity ^0.8.4;
contract Receive{
    event Received(address Sender,uint Value,string message);
    receive()external payable {
        emit Received(msg.sender,msg.value,'receive');
    }

}