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
    function processProof(bytes32[] memory proof,bytes32 leaf) internal pure returns(bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++){
            computedHash = _hashpair(computedHash,proof[i]);
        }
        return computedHash;  
    }
    function _hashpair(bytes32 a,bytes32 b)private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a,b)) : keccak256(abi.encodePacked(b,a));
    }
}
contract MerkleTree is ERC721 {
    bytes32 immutable public root;
    mapping(address => bool) public mintedAddress;

    constructor(string memory name,string memory symbol,bytes32  merkleroot) ERC721 (name,symbol){
        root = merkleroot;
    }
    function mint(address,account,uint256 tokenId,bytes[] calldata proof) external{
        require(_verify(_leaf(account), proof),"Invalid merkle proof");
        require(!mintedAddress[account],"Already minted!");

        mintedAddress[account] = true;
        _mint(account, tokenId);
    }
    function _leaf(address account)
    internal pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(account));
    }
    function _verify(bytes32 leaf, bytes32[] memory proof)
    internal view returns (bool)
    {
        return MerkleProof.verify(proof,root,leaf);
    }
}