//SPDX-License-Identifier:MIT
//wtf.academy
pragma solidity ^0.8.4;

contract Proxy {
    address public implementation;
// 逻辑合约地址。implementation合约同一个位置的状态变量类型必须和Proxy合约的相同，不然会报错。
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
            //calldatacopy(t, f, s)：将calldata（输入数据）从位置f开始复制s字节到mem（内存）的位置t
            let result := delegatecall(gas(), _implementation, 0, calldatasize(),0,0)
            //delegatecall(g, a, in, insize, out, outsize)：调用地址a的合约，输入为mem[in..(in+insize)) ，
            //输出为mem[out..(out+outsize))， 提供gwei的以太坊gas。这个操作码在错误时返回0，在成功时返回1。
            returndatacopy(0,0,returndatasize())
            //returndatacopy(t, f, s)：将returndata（输出数据）从位置f开始复制s字节到mem（内存）的位置t
            switch result
            //switch：基础版if/else，不同的情况case返回不同值。可以有一个默认的default情况。
            case 0 {
                revert(0, returndatasize())
                //return(p, s)：终止函数执行, 返回数据mem[p..(p+s))
            }
            default{
                return(0,returndatasize())
                //revert(p, s)：终止函数执行, 回滚状态，返回数据mem[p..(p+s))
            }
        }
    }
}
contract Logic {
        address public implementation;// 与Proxy保持一致，防止插槽冲突

        uint public x = 99;
        event CallSuccess();

        function increment() external returns(uint) {
            emit CallSuccess();
            return x + 1;
        }// 这个函数会释放CallSuccess事件并返回一个uint。
    // 函数selector: 0xd09de08a
}
contract Caller {//Caller合约，调用代理合约，并获取执行结果
    address public proxy;//proxy：状态变量，记录代理合约地址。

    constructor(address _proxy){
        proxy = _proxy;
    }

    function increase() external returns(uint) {// 通过代理合约调用increment()函数
   // increase()：利用call来调用代理合约的increment()函数，并返回一个uint。在调用时，
    //我们利用abi.encodeWithSignature()获取了increment()函数的selector。
    //在返回时，利用abi.decode()将返回值解码为uint类型。
        ( , bytes memory data) = proxy.call(abi.encodeWithSignature("increment()"));
        return abi.decode(data,(uint));
    }
}

