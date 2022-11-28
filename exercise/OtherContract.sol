//SPDX-License-identifier:MIT
pragma solidity ^0.8.4;
contract OtherContract {
    uint256 private _x = 0;
    event Log(uint amount, uint gas);
    function getBalance() view public returns(uint) {//返回ETH余额
        return address(this).balance;
    }
    function setx(uint256 x) external payable{//调整状态变量_x转ETH
        _x = x;
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }
    function get() external view returns(uint x){//读取_x
        x = _x;
    }
}
contract CallContract{
    function callSetX(address _Address, uint256 x) external{
        OtherContract(_Address).setX(x);
    }
    function callGetX(OtherContract _Address)external view returns(uint x){
        x = _Address.get();
    }
    function callGetX2(address _Address)external view returns(uint x){
        OtherContract oc = OtherContract(_Address);
        x = oc.get();
    }
    function setXTransferETH(address otherContract,uint256 x) payable external{
        OtherContract(otherContract).setx{value: msg.value}(x);
        
    }
}