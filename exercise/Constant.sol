pragma solidity ^0.8.4;
contract Constant{
    uint256  public constant CONSTANT_NUM = 10;
    string public constant CONSTANT_SRING = "0xAA";
    bytes public constant CONSTANT_BYYES = "WTF";
    address public constant CONSTANT_ADDRESS = 0x0000000000000000000000000000000000000000;

    uint256 public immutable IMMUTABLE_NUM = 99999999;
    address public immutable IMMUTABLE_ADDRESS;
    uint public immutable IMMUTABLE_BLOCK;
    uint public immutable IMMUTABLE_TEST;

    constructor(){
        IMMUTABLE_ADDRESS = address(this);
        IMMUTABLE_BLOCK = block.number;
        IMMUTABLE_TEST = test();
    }
    function test() public pure returns(uint256) {
        uint256 what = 444;
        return(what);
    }
}