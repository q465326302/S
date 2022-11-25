//SPDX-License-Ldentifer:MIF
pragma solidity ^0.8.4;
library Strings{
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef" ;
    function toString(uint256 value) public pure returns (string memory){
        if (value == 0){
            return"0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp !=0){
            digits ++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0){
            digits -= 1;
            buffer[digits] = bytes1(uint8(48+uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function toHexString(uint256 value) public pure returns(string memory){
        if (value == 0){
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp !=0 ){
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    function toHexString(uint256 value,uint256 length) public pure returns (string memory){
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1;i > 1; --i){
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0,"Strings:hex length insufficient");
        return string(buffer);
    }
}
contract UseLibray{
    using Strings for uint256;
    function getString1(uint256 _number) public pure returns(string memory){
         return _number.toHexString()   
    }
    function getString2(uint256 _number) public pure returns(string memory){
        return strings.toHexString(_number);
    }
}