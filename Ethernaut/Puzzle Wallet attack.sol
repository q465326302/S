pragma solidity ^0.8.0;

contract Attack {
    address payable public wallet;

    constructor(address payable _wallet) {
        wallet = _wallet;
    }

    function attack() public {
        wallet.call{value: address(this).balance}("");
    }
    
    // fallback function to receive ether
    receive() external payable {}
    
}