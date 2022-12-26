//SPDX-License-Identifier: MIT
//auther:@0xAA_Science from wtf.academy
pragma solidity ^0.8.4;

contract MultuisigWallet {
    event ExecutionSuccess(bytes32 txHash);
    event ExecutionFailure(bytes32 txHash);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public ownerCount;
    uint256 public threshold;
    uint256 public nonce;

    receive() external payable{}

    constructor(
        address[] memory _owners,
        uint256 _threshold
    ) {
        _setupOwners(_owners, _threshold);
    }

    
}