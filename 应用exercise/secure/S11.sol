//SPDX-License-Identifier:MIT
//By 0xAA
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FreeMint is ERC721 {
    uint256 public totalSupply;

    constructor() ERC721("Free Mint NFT","FreeMint"){}

    function mint() external {
        _mint(msg.sender, totalSupply);
        totalSupply++;
    }
}