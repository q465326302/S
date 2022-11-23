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
    function ternaryTest(uint256 x,uint256 y) public pure returns(uint256) {
        return x >= y ? x: y;
    }
    function insertionSort(uint[] memory a) public pure returns(uint[] memory) {
        for (uint i = 1;i < a.length;i++) {
            uint temp = a[i];
            uint j = i;
            while( (j >= 1) && (temp < a[j-1]) ) {
                a[j] = a[j-1];
                j--;
            }
            a[j] = temp;
        }
        return(a);
    }
}