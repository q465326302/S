pragma solidity ^0.8.4;
contract Mapping{
    mapping(uint => address) public idToAddress;
    mapping(address => address) public swapPair;
    struct Student{
        uint256 id;
        uint256 score;
    }
    //mapping(Struct => uint) public testVar;
    function writeMap (uint _Key,address _Value) public{
        idToAddress[_Key] = _Value;
    }
}