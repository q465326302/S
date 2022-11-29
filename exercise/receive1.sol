// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
contract Receive1{//合约保留所有发送给它的eth，没办法取回
    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender,msg.value);
    }
}