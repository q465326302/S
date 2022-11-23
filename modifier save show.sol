pragma solidity ^0.8.4;
contract Number{
    uint [] array1;
    address public owner;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    constructor() {
        owner = msg.sender;
    }
    function save(uint[] calldata _number) public{
        for(uint i = 0;i <_number.length;i++){
             array1.push(_number[i]);
        }
       
    }
    function show() public view returns(uint[] memory array2){
        array2 = array1;
    }
    function del() public onlyOwner{
        array1.pop();
    }
}