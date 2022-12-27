// SPDX-License-Identifier: MIT
// by 0xAA
pragma solidity ^0.8.4;
contract Bank {
    mapping (address => uint256) public balanceOf;
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }
    function withdrow() external {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0,"Insuffucuent balance");
        (bool success, ) = msg.sender.call{value:balance}("");
        require(success, "Failed to send ETH");
        balanceOf[msg.sender] = 0;
    }
}