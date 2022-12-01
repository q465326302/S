//SPDX-License-Identifer:MIT
pragma solidity ^0.8.4;
contract OnlyEven{
    constructor(uint a){
        require(a != 0,"invalid number");
        assert(a != 1);
    }
    function onlyEven(uint256 b) external pure returns(bool success){
        require(b % 2 ==0, "Ups! Reverting");
        success = true;
    }
}

contract TryCatch {
    event SuccessEvent();
    event CatchEvent(string message);
    event CatchByte(bytes data);

    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);

    }
    function execute(uint amout) external returns (bool success){
        try even.onlyEven(amout) returns(bool _success){
            emit SuccessEvent();
            return _success;

        } catch Error(string memory reason){
            emit CatchEvent(reason);
        }
    }
    function executeNew(uint a) external returns(bool success) {
        try new OnlyEven(a) returns(OnlyEven _even){
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            emit CatchByte(reason);
        }
    // executeNew(0)会失败并释放`CatchEvent`
    // executeNew(1)会失败并释放`CatchByte`
    // executeNew(2)会成功并释放`SuccessEvent`
    }
}