pragma solidity ^0.8.4;
contract p{
    mapping(string => string) private P;
    function put(string calldata _K,string calldata _V) public{
        P[_K] = _V;

    }
    function get(string calldata _K) public view returns(string memory _V){
        _V = P[_K];
    }
    
}