// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Proxy.sol";
contract Store{
    address internal storeAddress;
    uint256 internal storeId;

    uint256[] internal numberStore;
    
    constructor() payable {
        storeAddress = msg.sender;
    }
    
    function show() external view  returns(uint256[] memory _nums) {
        _nums = numberStore;
    }
    
}
contract Proxy1 is Proxy{
    
        //新建一个数字仓库
    function newStore(uint256[] calldata data) external  virtual override returns(uint256 storeId, address storeAddress){
        Store proxy = new Store(); 
        uint256 storeId = _storeId;
        address storeAddress =  _storeAddress;
    }
    //向特定的数字仓库增加元素
    function add(uint256 storeId, uint256 number) external virtual override{
        storeId = _storeId;
        _storeAddress.push(number);  
    }
 
    //删除特定的数字仓库的末尾元素
    function del(uint256 storeId) external virtual override{
        _storeAddress.pop();
    }


    //从特定的数字仓库里获取特定位置的数值
    function get(uint256 storeId, uint256 index) external view virtual returns(uint256);

    //修改特定数字仓库里特定位置的元素为新数值
    function edit(uint256 storeId, uint256 index, uint256 number) external virtual;

}
