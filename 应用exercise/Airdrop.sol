// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;

import "./IERC20.sol"; 

contract Airdrop {

    function multiTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) external {
        require(_addresses.length == _amounts.length,"Lengths of Addresses and Amounts NOT EQUAL");
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require (token.allowance(msg.sender, address(this)) > _amountSum, "Need Approve ERC20 token");

        for (uint256 i; i < _addresses.length; i++) {
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
        }
    }

    function multiTransrETH(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        require(_addresses.length == _amounts.length,"Lengths of Amounts NOT EQUAL");
        uint _amountSum = getSum(_amounts);
        require(msg.value == _amountSum,"Trans amount error");
        for (uint256 i = 0; i < _addresses.length; i++){
            _addresses[i].transfer(_amounts[i]);
        }
    }
    
    function getSum(uint256[] calldata _arr) public pure returns(uint sum)
    {
        for(uint i = 0; i <_arr.length; i++)
            sum = sum +_arr[i];
    }
}
contract ERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;
    uint256 public override totalSupply;
    constructor(string memory name_, string memory)
}