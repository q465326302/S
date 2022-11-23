pragma solidity ^0.8.4;
contract Event{
    event Transfer(address indexed from,address indexed to,uint256 value);
    function _transfer(
        address form,
        address to,
        uint256 amout
    ) external {
        _balances[from] = 10000000;
        _balances[from] -= amout;
        _balances[to] += amout;

        emit transfer(form, to, amout);
    }
 
}