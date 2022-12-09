//SPDX-Licen-Identifier:MIF
pragma solidity ^0.8.4;
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./WTFApe.sol";

contract NFTSwap is IERC721Receiver{
    event List(address indexed seller, address indexed nftaddr, uint indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftaddr,uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftaddr, uint256 indexed tokenId);
    event Updata(address indexed seller, address indexed nftaddr,uint256 indexed tokenId,uint256 newPrice);

    struct owner
}