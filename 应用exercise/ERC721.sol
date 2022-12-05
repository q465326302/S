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

    using Address for address;// 使用Address库，用isContract来判断地址是否为合约
    using Strings for uint256;// String库 字符串

    string public override name;
    string public override symbol;
    mapping(uint => address) private _owners;// tokenId 到 owner address 的持有人映射
    mapping(address => uint) private _balances;// address 到 持仓数量 的持仓量映射
    mapping(uint => address) private _tokenApprovals;// tokenID 到 授权地址 的授权映射
    mapping(address => mapping(address => bool)) private _operatirApprovals;
    //  owner地址。到operator地址 的批量授权映射

    constructor(string memory name_, string memory symbol_) {
        //构造函数，初始化name和symbol
        name = name_;
        symbol = symbol_;
    }
    function supportsInterface(bytes4 interfaceId) // IERC165接口supportsInterface函数
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
        // 实现IERC721的balanceOf，利用_balances变量查询owner地址的balance。
        require(owner != address(0),"owner = zero address");
    }

    function ownerOf(uint tokenId) public view override returns (address owner) {
        // 实现IERC721的ownerOf，利用_owners变量查询tokenId的owner。
        owner = _owners[tokenId];
        require(owner != address(0),"token doesn't exist");
    }

    function isApprovedForAll(address owner,address operator)
     // 实现IERC721的isApprovedForAll，利用_operatorApprovals变量查询owner地址是否将所持NFT批量授权给了operator地址。
        external
        view
        override
        returns(bool)
    {
        return _operatirApprovals[owner][operator];
    }

    function setApprovalForAll(address operator, bool approved) external override {
        // 实现IERC721的setApprovalForAll，将持有代币全部授权给operator地址。调用_setApprovalForAll函数
        _operatirApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint tokenId) external view override returns(address){
        // 实现IERC721的getApproved，利用_tokenApprovals变量查询tokenId的授权地址。
        require(_owners[tokenId] != address(0),"token doesn't exist");
        return _tokenApprovals[tokenId];
    }

    function _approve(
        // 授权函数。通过调整_tokenApprovals来，授权 to 地址操作 tokenId，同时释放Approval事件
        address owner,
        address to,
        uint tokenId
        
    )private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function approve(address to, uint tokenId) external override {
       // 实现IERC721的approve，将tokenId授权给 to 地址。条件：to不是owner，且msg.sender是owner或授权地址。调用_approve函数
        address owner = _owners[tokenId];
        require(
            msg.sender == owner ||_operatirApprovals[owner][msg.sender],
            "not owner nor approved for all"
        );
        _approve(owner, to,tokenId);
    }

    function _isApprovedOrOwner(
         // 查询 spender地址是否可以使用tokenId（他是owner或被授权地址）。
        address owner,
        address spender,
        uint tokenId
    ) private view returns (bool) {
        return (spender == owner ||
            _tokenApprovals[tokenId] == spender ||
            _operatirApprovals[owner][spender]);
    }
     /*
     * 转账函数。通过调整_balances和_owner变量将 tokenId 从 from 转账给 to，同时释放Transfer事件。
     * 条件:
     * 1. tokenId 被 from 拥有
     * 2. to 不是0地址
     */
    function _transfer(
        address owner,
        address from,
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

     // 实现IERC721的transferFrom，非安全转账，不建议使用。调用_transfer函数
    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        address owner = ownerOf(tokenId);
        require(
            _isApprovedOrOwner(owner,msg.sender, tokenId),
            "not owner not approved"
        );
        _transfer(owner,from, to,tokenId);
    }

    /**
     * 安全转账，安全地将 tokenId 代币从 from 转移到 to，会检查合约接收者是否了解 ERC721 协议，以防止代币被永久锁定。调用了_transfer函数和_checkOnERC721Received函数。条件：
     * from 不能是0地址.
     * to 不能是0地址.
     * tokenId 代币必须存在，并且被 from拥有.
     * 如果 to 是智能合约, 他必须支持 IERC721Receiver-onERC721Received.
     */
    function _safeTransfer(
        address owner,
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private{
        _transfer(owner, from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data),"not ERC721Receiver");
    }

    //现IERC721的safeTransferFrom，安全转账，调用了_safeTransfer函数
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
        _safeTransfer(owner, from, to, tokenId, _data);
        
    }

     // safeTransferFrom重载函数
    function safeTransferForm(
        address from,
        address to,
        uint tokenId
    ) external override {
        safeTransferForm(from, to, tokenId, "");
    }

    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0),"mint to zeero address");
        require(_owners[tokenId] == address(0),"token already minted");
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to,tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "not owner of token");
        _approve(owner, address(0), tokenId);
        _balances[owner] -= 1;
        emit Transfer(owner, address(0), tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns(bool) {
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

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owners[tokenId] != address(0),"Token NOT Exist");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns(string memory){
        return "";
    }
    

}