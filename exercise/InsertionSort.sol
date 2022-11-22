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
        uint sum = 2;
        for(uint i = 0;i <8;i++){
            sum += i;
        }
        return(sum);
    }
    function whileTest() public pure returns(uint256) {
        uint sum = 0;
        uint i = 0;
        while(i < 10){
            sum += i ;
            i++;
        }
        return(sum);
    }
    function doWileTest() public pure returns(uint256) {
        uint sum = 0;
        uint i = 0;
        do{
            sum += 1;
            i++;
        }while (i < 10);
        return(sum);
    }
}