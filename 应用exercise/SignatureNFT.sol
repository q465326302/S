// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721.sol";

library ECDSA{
    function verify(bytes32 _msgHash, _signature,address _signer) internal pure returns (bool){
        return recoverSigner(_msgHash, _signature) == _signer;
    }
} 