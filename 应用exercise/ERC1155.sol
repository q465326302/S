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

    function safeTransferFrom(//安全转账 将 amount单位的id币从from转to
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        address operator = msg.sender;
        require(
            from == operator || isApprovadForAll(from, operator),
            "ERC1155:caller is not token owner nor approved"
        );//调用者是持有者或者被授权
        require(to != address(0),"ERC1155:transfer to the zero address");
        //from地址有足够持仓
        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount,"ERC1155:insufficient balance for transfer");
        //更新持仓量
        unchecked {
            _balances[id][from] = fromBalance - amount;

        }
        _balances[id][to] += amount;
        emit TransferSingle(operator,from,to,id,amount);
        _doSafeTransferAcceptanceCheck(operator,from,to, id,amount,data);
        //安全检查
    }
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        address operator = msg.sender;
        require(
            from == operator || isApprovadForAll(from,operator),
            "REC1155:caller is not token owner nor approved"
        );
        require(ids.length == amounts.length,"ERC1155:ids and amounts length mismatch");
        require(to != address(0),"ERC1155:transfer to the zero address");
        
        for (uint256 i = 0; i < ids.length;++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];
            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;

        }
        emit TransferBatch(operator, from ,to ,ids ,amounts);

        _doSafeTransferAcceptanceCheck(operator,from, to, ids,amounts, data);
    }
    function _mint(//铸造
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0),"ERC1155:mint to the zero address");
        address operator = msg.sender;
        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0),to,id, amount, data);
    }
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0),"ERC1155: mint to the zero address");
        require(ids.length == amounts.length,"ERC1155: ids and amounts length mismatch");
        address operator = msg.sender;
        for(uint256 i = 0; i < ids.length; i++){
            _balances[ids[i]][to] += amount[i];
        }
        emit TransferBatch(operator,address(0),to, ids,amounts);
        _doSafeTransferAcceptanceCheck(operator,address(0), to,ids, amounts, data);
    }


}