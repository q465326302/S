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
            owners.push(owner);
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

    function checkSignatures(
        //检查签名和交易数据是否对应。如果是无效签名，交易会revert
        bytes32 dataHash,
        bytes memory signatures
    ) public view{
        uint256 _threshold = threshold;
        require(_threshold > 0,"WTF5005");
        // 读取多签执行门槛
        require(signatures.length >= _threshold * 65,"WTF5006");
        // 检查签名长度足够长

        address lastOwner = address(0);
        address currentOwner;
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 i;
    // 通过一个循环，检查收集的签名是否有效
    // 大概思路：
    // 1. 用ecdsa先验证签名是否有效
    // 2. 利用 currentOwner > lastOwner 确定签名来自不同多签（多签地址递增）
    // 3. 利用 isOwner[currentOwner] 确定签名者为多签持有人
        for (i= 0; i < _threshold; i++){
            (v, r, s) = signatureSplit(signatures, i);
            currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",dataHash)),v, r, s);
            // 利用ecrecover检查签名是否有效
            require(currentOwner > lastOwner && isOwner[currentOwner],"WTF5007");
            lastOwner = currentOwner;
        }
    }
    function signatureSplit(bytes memory signatures, uint256 pos)
    // 将单个签名从打包的签名分离出来
        internal
        pure 
        returns (
            uint8 v,
            bytes32 r,
            bytes32 s
        )
    {
        //参数分别为打包签名signatures和要读取的签名位置pos。利用了内联汇编，将签名的r，s，和v三个值分离出来。
        assembly {
            // 签名的格式：{bytes32 r}{bytes32 s}{uint8 v}
            let signaturePos := mul(0x41,pos)
            r := mload(add(signatures,add(signaturePos,0x20)))
            s := mload(add(signatures,add(signaturePos,0x40)))
            v := and(mload(add(signatures,add(signaturePos,0x41))),0xff)
        }
    }
    function encodeTransactionData(
        //将交易数据打包并计算哈希
        address to,//目标合约地址
        uint256 value,//支付的以太坊
        bytes memory data, //calldata
        uint256 _nonce,//交易的nonce.
        uint256 chainid//链id
    ) public pure returns(bytes32) {
        bytes32 safeTxHash = 
            keccak256(
                abi.encode(
                    to,
                    value,
                    keccak256(data),
                    _nonce,
                    chainid
                )
            );
        return safeTxHash;
    }
}