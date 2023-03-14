[
    {
        "contract" : true,
        "inputs":[],

        "name":"testFune",
        "outputs":[
            {
                "name":"",
                "type":"int256"
            }
        ],
        "payable":false,
        "stateMutablility":"pure",
        "type":"function"
    }
]
function weithdraw(uint weithdraw_amout) publie{}

pragma solidity ^0.8.13;
contract EVMStudy{
    bytes32 publie member;
    constructor(){}
    function setMember(bytes32 input) publie{
        member = input;
    }
}
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
    
}