//SPDX-License-Identifier:MIT
//wtf.academy
pragma solidity ^0.8.4;

contract Proxy {
    address public implementation;

    constructor(address _implementation){
        implementation = _implementation;
    }//初始化逻辑合约地址

    fallback() external payable {
        _delegate();
    }//回调函数，调用`_delegate()`函数将本合约的调用委托给 `implementation` 合约
    function _delegate() internal {
        assembly {
            let _implementation := sload(0)
            calldatacopy(0,0, calldatasize())
            let ressult := delegetecall(gas(), _implementation, 0, calldatasize(),0,0)
            returndatacopy(0,0,returndatasize())
            switch ressult
            case 0 {
                revert(0, returndatasize())
            }
            default(0,returndatasize())
        }
    }
}