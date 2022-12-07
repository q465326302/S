// SPDX-License-Identifier: MIT
// By 0xAA
pragma solidity ^0.8.4;

import "./ERC721.sol";


library MarkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    )internal pure returns(bool) {
    return processProof(proof, leaf) == root;
    }
    function processProof(bytes32 a,bytes32 b) private pure returns (bytes32){
        
    }
}