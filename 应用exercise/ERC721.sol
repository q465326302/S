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

    function _approve(
        address owner,
        address to,
        uint tokenId,
        
    )private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function approve(address to, uint tokenId) external override {
        address owner = _owners[tokenId];
        require(
            msg.sender == owner ||_operatirApprovals[owner][msg.sender],
            "not owner nor approved for all"
        );
        _approve(owner, to,tokenId);
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) private view returns (bool) {
        return (spender == owner ||
            _tokenApprovals[tokenId] == spender ||
            _operatirApprovals[owner][spender];)
    }

    function _transfer(
        address owner,
        address form,
        address to,
        uint tokenId
    ) private {
        require(from == owner,"not owner");
        require(to != address(0),"transfer to the zero address");
        _approve(owner, address(0),tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        address owner = ownerOf(tokenId),
        require(
            _isApprovedOrOwner(owner,msg.sender, tokenId),
            "not owner not approved"
        );
        _transfer(owner,from, to,tokenId);
    }
    function _sefeTransfer(
        address owner,
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private{
        _transfer(owner, from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data),"not ERC721Receiver")
    }
    function safeTransferForm(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) public override {
        address owner = ownerOf(tokenId);
        require(
            _isApprovedOrOwner(owner,msg.sender, tokenId),
            "not owner nor approved"
        );
        _sefeTransfer(owner, from, to, tokenId, _data);
        
    }

}