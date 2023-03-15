//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Proxy{
    // implementtation为以太坊地址
    address public implementation;

    constructor(address implementation_){
        implementation = implementation_;
    }

}
contract proxy{
    address public delegate;

    constructor(address _delegate) public{
        delegate = _delegate;

    }
    function() external payable {
        address to = delegate;
        assembly{
            calldatacopy(0,0,calldatasize())
            let result := delegatecall(gas(), to, 0, calldatasize(),0,0)
            result
        }
    }
}