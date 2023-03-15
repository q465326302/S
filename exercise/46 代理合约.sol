//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Proxy{
    // implementtation为以太坊地址
    address public implementation;

    constructor(address implementation_){
        implementation = implementation_;
    }
    fallback() external payable{
        _delegate();
    }
    function _delegate() internal{
        address _implementation = implementation;
        assembly{
            //calldatacopy(t, f, s)：将calldata（输入数据）从位置f开始复制s字节到mem（内存）的位置t
            //calldatacopy是汇编指令 合约调用时把所有数据和参数存在calldata
            calldatacopy(0, 0, calldatasize())
            // delegatecall调用implementation
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
                }
            default {
                return(0, returndatasize())
            }

        }
    }

}

contract Logic {
    address public implementation; // 与Proxy保持一致，防止插槽冲突
    uint public x = 99; 
    event CallSuccess(); // 调用成功事件

    // 这个函数会释放CallSuccess事件并返回一个uint。
    // 函数selector: 0xd09de08a
    function increment() external returns(uint) {
        emit CallSuccess();
        return x + 1;
    }
}

contract Caller{
    address public proxy;
    constructor(address _proxy){
        proxy = _proxy;
    }
    function increment() external returns(uint){
        ( , bytes memory data) = proxy.call(abi.encodeWithSignature("increment()"));
        return abi.decode(data,(uint));
    }
}
contract proxy{
    address public delegate;

    constructor(address _delegate) public{
        delegate = _delegate;

    }
    function pro() external payable {
        address to = delegate;
        assembly{
            calldatacopy(0,0,calldatasize())
            let result := delegatecall(gas(), to, 0, calldatasize(),0,0)
            returndatacopy(0,0,returndatasize())
            switch result
            case 0 {revert(0,returndatasize())}
            default {return(0,returndatasize())}
        }
    }
}