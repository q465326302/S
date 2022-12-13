//SPDX-license-Identifier:MIT
pragma solidity ^0.8.0;
import "./IERC165.sol";

interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    //单个代币转账事件（当`value`个`id`种类的代币被`operator`从`from`转账到`to`时释放

    event TransferBatch(//批量代币转账
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,//代币种类
        uint256[] value//代币数组
    );

    event ApprovalForAll(address indexed account,address indexed operator, bool approved);
    //批量授权
    event URI(string value,uint256 indexed id);
    //当“id”币的URI发生变化是释放，“value”成为新的URI
    
    function balanceOf(address account, uint256 id) external view returns(uint256);
    //持仓查询，返回“account的id种类币持仓量

    function balanceOfBatch(address[] calldata accounts,uint256[] calldata ids)
        external
        view
        returns(uint256[] memory);
        //批量持仓查询
    
    function setApprovalForAll(address operator,bool approved)external;
    //批量授权 调用者代币授权给operator地址
    function isApprovadForAll(address account, address operator) external view returns(bool);
    //批量授权查询 如授权地址operator被account授权 返回ture
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
    //安全转账 amount单位的id类币从from转to 有要求 如果调用者不是from地址而是授权地址 需要from的授权 
    //from地址需要有足够的持仓
    //如果接受方是合约，需要IERCReceive的onERC1155Received方法，返回相应的值
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amount,
        bytes calldata data
    ) external;
    //安全批量转账 要求ids和amount长度相等
    //同safetransferfrom一样，如接收方是合约 需IERCReceive的onERC1155Received方法，返回相应的值
}