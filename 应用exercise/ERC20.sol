//SPDX-Lincense-Identifer:MIT
//WTF Solidity by 0xAA

pragma solidity ^0.8.4;

interface IERC20{
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event totalSupply() external view returns (uint256);

    function totalSupply() external view returns(uint256);
}