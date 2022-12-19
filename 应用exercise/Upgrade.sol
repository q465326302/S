//SPDX-License-Identifier:MIT
//wtf.academy
pragma solidity ^0.8.4;

contract SimpleUpgrade {
    address public implementation;// 逻辑合约地址
    address public admin;// admin地址
    string public words;// 字符串，可以通过逻辑合约的函数改变

    constructor(address _implementation){
        // 构造函数，初始化admin和逻辑合约地址
        admin = msg.sender;
        implementation = _implementation;
    }

    fallback() external payable {  
         // fallback函数，将调用委托给逻辑合约
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    function upgrade(address newImplementation) external {
        // 升级函数，改变逻辑合约地址，只能由admin调用
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}
contract Logic1 {
    address public implementation;
    address public admin;
    string public words;

    function foo() public{
         // 改变proxy中状态变量，选择器： 0xc2985578
        words = "old";
    }
}

contract Logic2 {
    address public implementation;
    address public admin;
    string public words;

    function foo() public {
        words = "new";
    }
}