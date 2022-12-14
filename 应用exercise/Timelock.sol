//SPDX- License-Identififier: BSD- 3-Clause
pragma solidity ^0.8.4;
contract Timelock{
    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event NewAdmin(address indexed NewAdmin);
}