//SPDX-License-Identifier:MIT
//by 0xAA
pragma solidity ^0.8.4;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./Address.sol";
import "./String.sol";

contract ERC721 is IERC721, IERC721Metadata{

    using Address for address;
    using Strings for uint256;

    string public override name;
    string public override symbol;
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatirApprovals;

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }
    function supportsInterface(bytes4 interfaceId)
        external
        pure
        override
        returns(bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf(address owner) external view override returns (uint) {
        require(owner != address(0),"owner = zero address");
    }

    function ownerOf(uint tokenId) public view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0),"token doesn't exist");
    }

    function isApprovedForAll(address owner,address operator)
        external
        view
        override
        returns(bool)
    {
        return _operatirApprovals[owner][operator];
    }

    function setApprovalForAll(address operator, bool approved) external override {
        _operatirApprovals[msg.sender][operator] = approved;
        emit ApprovelForAll(msg.sender, operator, approved);
    }

    function getApproved(uint tokenId) external view override returns(address){
        require(_owners)[tokenId] != address(0),"token doesn't exist");
        return _tokenApprovals[tokenId];
    }

}