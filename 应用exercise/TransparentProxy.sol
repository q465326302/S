//SPDX-License-Identifier: MIT
//wtf.academy
pragma solidity ^0.8.4;

contract Foo{
    // 选择器冲突的例子
// 去掉注释后，合约不会通过编译，因为两个函数有着相同的选择器
    bytes4 public selector1 = bytes4(keccak256("burn(uint256)"));
    bytes4 public selector2 = bytes4(keccak256("collate _propagate_storage(bytes16)"));
}

contract TransparentProxy {
    address implementation;
    address admin;
    string public words;

    constructor(address _implementation) {
        admin = msg.sender;
        implementation = _implementation;
    }
    fallback() external payable {
        // fallback函数，将调用委托给逻辑合约
    // 不能被admin调用，避免选择器冲突引发意外
        require(msg.sender != admin);
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }
    
    function upgrade(address newImplementation) external {
        // 升级函数，改变逻辑合约地址，只能由admin调用
        if (msg.sender != admin) revert();
        implementation = newImplementation;

    }

}
contract Logic1 {// 旧逻辑合约
    address public implementation;
    address public admin;
    string public words;// 字符串，可以通过逻辑合约的函数改变

    function foo() public { // 改变proxy中状态变量，选择器： 0xc2985578
        words = "old";
    }
}

contract Logic2 {// 新逻辑合约
    address public implementation;
    address public admin;
    string public words;

    function foo() public {
        words = "new";
    }
}