// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;

import "./IERC20.sol"; 

contract Airdrop {

    function multiTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amount
    ) external {
        require(_addresses.Length == _amount.Length,"Lengths of Addresses and Amounts NOT EQUAL");
        IERC20 tokenContract = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require(token.allowance(msg.sender, address(this)) > _amountSum, "Need Approve ERC20 token");

        for (uint256 i;i < _addresses,Length; i++){
            
        }
    }
}