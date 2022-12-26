//SPDX-License-Identifier:MIT
//wtf.academy
pragma solidity ^0.8.4;

contract UUPSProxy {
    // UUPS的Proxy，跟普通的proxy像。
// 升级函数在逻辑函数中，管理员可以通过升级函数更改逻辑合约地址，从而改变合约的逻辑。
    address public implementation;// 逻辑合约地址
    address public admin;// admin地址
    string public words;// 字符串，可以通过逻辑合约的函数改变

    constructor( address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }

    fallback() external payable {
        // fallback函数，将调用委托给逻辑合约
        (bool success,bytes memory data) = implementation.delegatecall(msg.data);
    }
}

contract UUPS1{
    // UUPS逻辑合约（升级函数写在逻辑合约内）
    address public implementation;
    address public admin;
    string public words;

    function foo() public{
        words =  "old";
    }
    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }    // 升级函数，改变逻辑合约地址，只能由admin调用。选择器：0x0900f010
    // UUPS中，逻辑函数中必须包含升级函数，不然就不能再升级了。
}

contract UUPS2{
    // 新的UUPS逻辑合约
    address public implementation;
    address public admin;
    string public words;

    function foo() public{
        words =  "new";
    }

    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}