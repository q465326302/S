// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/TimeManipulation.sol";

contract TimeManipulationTest is Test {
    TimeManipulation public nft;
     address alice = vm.addr(1);

    function setUp() public {
        nft = new TimeManipulation();
    }
    function testMint() public {
        console.log("Condition 1: block.timestamp % 170 != 0");
        vm.warp(169);
        console.log("block.timestamp: %s", block.timestamp);
        vm.startPrank(alice);
        console.log("alice balance before mint: %s", nft.balanceOf(alice));
        nft.luckyMint();
        console.log("alice balance after mint: %s", nft.balanceOf(alice));
        console.log("Condition 2: block.timestamp % 170 == 0");
        vm.warp(17000);
        console.log("block.timestamp: %s", block.timestamp);
        console.log("alice balance before mint: %s", nft.balanceOf(alice));
        nft.luckyMint();
        console.log("alice balance after mint: %s", nft.balanceOf(alice));
        vm.stopPrank();
    }
}

