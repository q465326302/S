//SPDX-license-Identifier:MIT
pragma solidity ^0.8.0;
import "./IERC165.sol";

interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator,address indexed from, address indexed to, uint256 id,uint256 value);



}