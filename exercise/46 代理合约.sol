//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Proxy{
    // implementtation为以太坊地址
    address public implementation;

    constructor(address implementation_){
        implementation = implementation_;
    }
    
}