pragma solidity^0.8.4;
abstract contract InsertionSort{
    function InsertionSort(uint[] memory a ) public pure virtual returns(uint memory);
}
interface IERC721 is IERC165 {
    event Transfer(address indexed from,address indexed to,uint indexed tokenId);
}