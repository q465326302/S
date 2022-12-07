//SPDX-License-Identifier:MIT
//by 0xAA
pragma solidity ^0.8.4;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./Address.sol";
import "./String.sol";

contract ERC721 is IERC721,IERC721Metadata{
    using Address for address;
    using Strings for uint256;
    string public override name;
    string public override symbol_;
    mapping(uint =>address) private _owners;
    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor (string memory name_,string memory symbol_){
        name = name_;
        symbol = symbol_;
        
    }
        function supportsInterface(bytes4 interfaceId)
        external
        pure
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    function balanceOf(address owner) public view override returns(uint){
        require (owner != address(0),"zero");
        return _balances[owner];
    }
    
    function ownerOf(uint tokenId) public view override returns (address owner){
        owner = _owners[tokenId];
        require (owner != address(0),"not");
    }
    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            return
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                ) == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }
    function _safeTransfer(address owner,address from, address to, uint tokenId,bytes memory data) private{
        _transfer(owner,from, to, tokenId);
        require(_checkOnERC721Received(owner,from,to,tokenId),"not");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata _data
    ) public override{
       address owner = ownerOf(tokenId);
        require(
            _isApprovedOrOwner(owner, msg.sender, tokenId),"not ");
        _safeTransfer(owner, from, to, tokenId ,_data);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override{
        safeTransferFrom(from, to, tokenId,"");
    }

    function _transferfrom(address owner,address from, address to,uint tokenId) private {
        require(from == owner,"not owner");
        require(to != address(0),"not");
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId]=to;
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external{
        address owner = ownerOf[tokenId];
        _transfer(from, to , tokenId);
    }
    function _transfer(address owner,address from, address to,uint tokenId) private{
        require(from == owner,"not");
        require(to != address(0),"zero");
        _balances[from] -= 1;
        _balances[to] +=1;
        _owners[tokenId] = to;

        }
    
    function _approve(address owner, address to, uint tokenId)private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to,tokenId );
    }
    function approve(address to, uint256 tokenId) external override{
        address owner = _owners[tokenId];
        require(msg.sender == owner);
    }

    function setApprovalForAll(address operator, bool _approved) external override{
        _operatorApprovals[msg.sender][operator] = _approved;

    }

    function getApproved(uint256 tokenId) external  view override returns (address operator){
        require(_owners[tokenId] != address(0),"not");
        return _tokenApprovals[tokenId];

    }

    function isApprovedForAll(address owner,address operator) external view override returns(bool){
        return _operatorApprovals[owner][operator];
    }
    function _isApprovedOrOwner(address owner,address spender, uint tokenId) private view returns(bool){
        return(
            spender == owner ||
            _tokenApprovals[tokenId] == spender ||
            _operatorApprovals[owner][spender]
        );
    }
    function _mint(address to, uint tokenId)internal virtual{
        require(to != address(0), " ");
        require(_owners[tokenId] == address(0),"no ");
        _owners[tokenId] = to;
        _balances[to] = 1;
    
    }
    function _burn(uint tokenId) internal virtual{
        address owner = ownerOf(tokenId);
        require(msg.sender == owner,"not");
        _approve(owner,address(0),tokenId);
        _balances [owner] -=1;
        delete _owners[tokenId];
    }
}