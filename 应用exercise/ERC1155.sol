//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "./IERC1155.sol";
import "./IERC1155Receiver.sol";
import "./IERC1155MetadataURI.sol";
import "./Address.sol";
import "./String.sol";
import "./IERC165.sol";

contract ERC1155 is IERC165, IERC1155, IERC1155MetadataURI{
    using Address for address;//Address库，判断地址是否为合约
    using Strings for uint256;//用string库
    string public name;//token名称
    string public symbol;//token代号
    mapping (uint256 => mapping(address => uint256)) private _balances;
    //id币到账户account到余额blances的映射
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    //发起方地址address到授权operator到是否授权bool的批量授权映射
    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool){
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account]; 
    }
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public view virtual override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }
        return batchBalances;
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(msg.sender != operator,"ERC1155:setting approval status for self");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender,operator,approved);
    }
    function isApprovadForAll(address account,address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];    
    }


}