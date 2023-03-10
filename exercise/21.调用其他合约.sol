//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

//简单目标合约
contract OntherContract{
    //状态变量x为private（私有），初始值为0
    uint256 private _x = 0;
    //声明事件Log 再链上记录 amout 和 gas
    event Log(uint amout, uint gas);

    //公共只读函数getBlance,返回无符号整数类型值
    function getBalance() view public returns(uint) {
        //返回当前合约ETH余额
        return address(this).balance;
    }
    //接受以太币转帐 只能合约外部调用
    function setX(uint256 x) external payable{
        _x = x;
        //如mag.value大于0 则执行（msg.value` 是 Solidity 的一个全局变量，它存储了当前以太币交易中传递的以太币数量
        if(msg.value > 0){//如果转入eth 则触发Log log记录
            //当函数 `setX` 被调用时，将传递 `value` 变量值和当前交易可 用的 gas 数量给事件 `Log`，并触发它
            emit Log(msg.value,gasleft());
        }
    }
    //外部读取_x
    function getX()external view returns (uint x){
        x =_x;
    }
}
contract call{
    //外部调用从callsetx合约，含有两个参数
    function callsetX(address _addr,uint256 x) external{//传入合约地址
        OntherContract(_addr).setX(x);
}
    //把之前的address类型改成调用合约名即可调用目标函数 getX(),函数返回uint类型变量x
    function callgetX(OntherContract _addr) external view returns(uint x){//传入合约地址
        //通过调用_addr合约中的函数getx（），并将返回值赋值给当前合约的uint型变量x
        x = _addr.getX();

    }
    //通过调用_addr合约上的get（）函数 获取该函数返回的uint变量值并返回给调用者
    function callgetX2(address _addr) external view returns(uint x){
        //OntherContract类型变量oc = 地址——addr创建onthC类型的合约实例
        //调用其他合约的函数或者变量 需要先通过地址创建对应合约实例
        //通过实例再调用其他合约的函数
        OntherContract oc = OntherContract(_addr);
        //将返回值赋值给当前合约的uint型变量x
        //调用已经实例化的合约变量的函数，并将返回值赋值给当前合约的变量
        x = oc.getX();
    }
    //同时对一个合约变量进行设置和eth转移操作
    //调用时 需要将需要转移的地址和带设定的x值作为参数输入 并把eth
    //向制定地址转移一定数量eth
    function setXTransferETH(address ontherContract, uint256 x) payable external{
        
        OntherContract(ontherContract).setX{value:msg.value}(x);
        
    }
}