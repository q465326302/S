//SPDX-License-Identifier: MIT
//auther:@0xAA_Science from wtf.academy
pragma solidity ^0.8.4;

contract MultuisigWallet {
    event ExecutionSuccess(bytes32 txHash);
    event ExecutionFailure(bytes32 txHash);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public ownerCount;
    uint256 public threshold;
    uint256 public nonce;

    receive() external payable{}

    constructor(
        address[] memory _owners,
        uint256 _threshold
    ) {
        _setupOwners(_owners, _threshold);
    }

    function _setupOwners(address[]memory _owners, uint256 _threshold) internal {
     /// @dev 初始化owners, isOwner, ownerCount,threshold 
    /// @param _owners: 多签持有人数组
    /// @param _threshold: 多签执行门槛，至少有几个多签人签署了交易
        require(threshold == 0, "WTF5000");// threshold没被初始化过
        require(_threshold <= _owners.length,"WTF5001");// 多签执行门槛 小于 多签人数
        require(_threshold >= 1,"WTF5002");// 多签执行门槛至少为1

        for(uint256 i = 0;i < _owners.length; i++) {
            address owner =_owners[i]; 
            require(owner != address(0) && owner != address(this) && !isOwner[owner],"WTF5003");
            // 多签人不能为0地址，本合约地址，不能重复
            owner.push(owner);
            isOwner[owner] = true;
        }
        ownerCount = _owners.length;
        threshold = _threshold;
    }
    function exeTransaction(
        // 在收集足够的多签签名后，执行交易
        address to,
        uint256 value,
        bytes memory data,
        bytes memory signatures
    ) public payable virtual returns (bool success) {
        bytes32 txHash = encodeTransactionData(to,value,data,nonce,block.chainid);
        // 编码交易数据，计算哈希
        nonce++;
        // 增加nonce
        checkSignatures(txHash, signatures);// 检查签名
        (success, ) =to.call{value:value}(data);
        // 利用call执行交易，并获取交易结果
        require(success , "WTF5004");
        if (success) emit ExecutionSuccess(txHash);
        else emit ExecutionFailure(txHash);
    }
}