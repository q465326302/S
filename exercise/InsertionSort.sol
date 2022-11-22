pragma solidity ^0.8.4;
contract InsertionSort{
    //if-else;
    function ifElseTest(uint256 _number) public pure returns(bool) {
        if(_number ==0) {
            return(true);
        }else{
            return(false);
        }
    }
    function forLoopTest() public pure returns(uint256){
        uint sum = ;
        for(uint i = 0;i <10;i++){
            sum += i;
        }
        return(sum);
    }
}