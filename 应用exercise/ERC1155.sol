//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "./IERC1155.sol";
import "./IERC1155Receiver.sol";
import "./IERC1155MetadataURI.sol";
import "./Address.sol";
import "./String.sol";
import "./IERC165.sol";

contract ERC1155 is IERC165, IERC1155, IERC1155MetadataURI{
    using Address for address;
    using Strings for uint256;
    string public name;
    string public symbol;
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    
    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

}