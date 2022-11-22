pragma solidity ^0.8.4;
contract Constructor{
    address owner;
    constructor() {
        owner = msg.sender;
    }
}