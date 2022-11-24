// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Overloding{
    function saySomething() public pure returns(string memory){
    return("Nothing");
    }
    function saySomething(string memory something) public pure returns(string memory){
        f(500);
        return(something);
    }
    
    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }
    function f(uint256 _in) public pure returns (uint256 out) {
        out = _in;
    }

}