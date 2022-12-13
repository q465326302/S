//SPDX-License-Identifier:MIT
//auther:0xAA
//original contract on ETH: https://rinkeby.etherscan.io/token/0xc778417e063141139fce010982780140aa0cd5ab?a=0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2#code

pragma solidity ^0.8.0;
import "./ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed dst, uint wad);
    event Withrawal(address indexed src, uint wad);

    constructor() ERC20("WERH","WETH"){
        
    }
}