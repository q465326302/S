//SPDX-License-Identifier:MIT
pragma solidity ^0.8.1;

library Address {
    function isCont(address account) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}