//SPDX- License-Identififier: BSD- 3-Clause
pragma solidity ^0.8.4;
contract Timelock{
    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event NewAdmin(address indexed NewAdmin);

    address public admin;
    uint public constant GRACE_PETIOD = 7 days;
    uint public delay;
    mapping (bytes32 => bool) public QueueTransactions;

    modifier onlyOwner(){
        require(msg.sender == admin, "Timelock :Caller not admin");
        _;
    }
    
    modifier onlyTimelock() {
        require(msg.sender == address(this),"Timelock :Caller not Timelock");
        _;
    }

    constructor(uint _delay) {
        delay = _delay;
        admin = msg.sender;
    }

    function changeAdmin(address NewAdmin) public onlyTimelock {
        //改变管理员地址，调用者必须是Timelock合约
        admin = NewAdmin;
        emit NewAdmin(newAdmin);
    }

    function queueTransaction(address target, //目标合约地址
    uint256 value,//发送eth数额
    string memory signature, //要调用的函数签名（function signature）
    bytes memory data,//call data，里面是一些参数
    uint256 executeTime//交易执行的区块链时间戳
    ) public onlyOwner returns (bytes32) {//创建交易并添加到时间锁队列中 函数
        // 检查：交易执行时间满足锁定时间
        require(executeTime >= getBlockTimestamp() + delay,"Timelock : queueTransaction : Estimated execution block must satisfy delay.");
    
        // 计算交易的唯一识别符：一堆东西的hash
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        // 将交易添加到队列
        QueueTransactions[txHash] = true;
        emit QueueTransaction(txHash,target, value, signature, data, executeTime);
        return txHash;
    }
}