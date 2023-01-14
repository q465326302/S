// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessControlExploit is ERC20, Ownable {
    constructor() ERC20("Wrong Access", "WA") {}

    function badMint(address to, uint amount) public {
        _mint(to, amount);
    }
    function goodMint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }
    function badBurn(address account, uint amount) public {
        _burn(account, amount);
    }
    function goodBurn(address account, uint amount) public {
        if(msg.sender != account){
            _spendAllowance(account, msg.sender, amount);
        }
        _burn(account, amount);
    }

}