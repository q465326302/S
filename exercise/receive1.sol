// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
contract Receive1{
    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender,msg.value);
    }
}