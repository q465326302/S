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
            
            let result := delegatecall(gas(), _implementation, 0, calldatasize(),0,0)
            returndatacopy(0,0,returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default{
                return(0,returndatasize())
            }
        }
    }
}
contract Logic {
        address public implementation;
        uint public x = 99;
        event CallSuccess();

        function increment() external returns(uint) {
            emit CallSuccess();
            return x + 1;
        }
}
contract Caller {
    address public proxy;

    constructor(address _proxy){
        proxy = _proxy;
    }

    function increase() external returns(uint) {
        ( , bytes memory data) = proxy.call(abi.encodeWithSignature("increment()"));
        return abi.decode(data,(uint));
    }
}

