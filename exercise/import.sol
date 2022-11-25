//SPDX-License-Identifier:MIF
pragma solidity ^0.8.4;
import * as Wowo from "./Yeye";

contract Import {
    using Address for address;
    Yeye yeye = new Yeye();
    function test() external{
        yeye.hip();
    }
}