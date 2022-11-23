pragma solidity ^0.8.4;
contract Constructor{
    address owner;
    constructor() {
        owner = msg.sender;
    }
   modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }
    function changeOwner(address _newOwner) external onlyOwner{
        owner = _newOwner;
    }
}