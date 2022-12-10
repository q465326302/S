//SPDX-Lincense-Identifier：MIT
pragma solidity ^0.8.4;

import "./ERC721.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomNumber is ERC721,VRFConsumerBase{
    uint256 public totalSupply = 100;
    uint256[100] public ids;
    uint256 public mintCount;
    bytes32 internal keyHash;
    uint256 internal fee;
    mapping(bytse => address) public requireToSender;

    
}