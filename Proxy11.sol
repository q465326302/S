// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Proxy.sol";

contract Store{
    
    uint[] private array1;

    constructor (uint256[] memory _nums) {//每调用一次new的时候 建立空数组
        array1 = _nums;
    }

    function save(uint _num) public {// 
           array1.push(_num);
    }

    function show() public view returns(uint[] memory arrary2) {
        arrary2 = array1;
    }
    function get(uint _index) public view returns(uint256 x){
        x = array1[_index];
    }
    function del() public {
        array1.pop();
    }
    function edit(uint256 index , uint256 number) public {
        array1[index] = number;
    }

}

contract Test2 is Proxy {
    address[] stores;//定义stores地址
    
    //新建一个数字仓库
    function newStore(uint256[] memory data) external  virtual override returns(uint256 storeId, address storeAddress){
        Store store = new Store(data);//建新合约
        storeAddress = address(store);
        stores.push(storeAddress);
        storeId = stores.length-1;//索引要减一
    }
    
    //向特定的数字仓库增加元素
    function add(uint256 storeId, uint256  number) external virtual override  {
         Store store = Store(stores[storeId]);
         store.save(number);

    }

    //删除特定的数字仓库的末尾元素
    function del(uint256 storeId) external virtual override {
        Store store = Store(stores[storeId]);
        store.del();
    }

    //从特定的数字仓库里获取特定位置的数值
    function get(uint256 storeId, uint256 index) external view virtual override returns(uint256){
        Store store = Store(stores[storeId]);
        return store.get(index);
    }

    //修改特定数字仓库里特定位置的元素为新数值
    function edit(uint256 storeId, uint256 index, uint256 number) external virtual override {
        Store store = Store(stores[storeId]);
        store.edit(index,number);//

    }
}