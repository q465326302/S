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
        //被修饰的函数只能被管理员执行。
        require(msg.sender == admin, "Timelock :Caller not admin");
        _;
    }
    
    modifier onlyTimelock() {
        //被修饰的函数只能被时间锁合约执行。
        require(msg.sender == address(this),"Timelock :Caller not Timelock");
        _;
    }

    constructor(uint _delay) {
        //初始化交易锁定时间（秒）和管理员地址
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
    //调用这个函数时，要保证交易预计执行时间executeTime大于当前区块链时间戳+锁定时间delay。
    //交易的唯一标识符为所有参数的哈希值，利用getTxHash()函数计算。
    //进入队列的交易会更新在queuedTransactions变量中，并释放QueueTransaction事件。
    
    function CancelTransaction(address target, //取消特定交易。
    uint256 value,
    string memory signature,
    bytes memory data, 
    uint256 executeTime
    ) public onlyOwner {
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        // 计算交易的唯一识别符：一堆东西的hash
        require(QueueTransactions[txHash], "Timelock : cancelTransaction: Transaction hasn't been queued.");
       // 检查：交易在时间锁队列中
        queuedTransactions[txHash] = false;
        // 将交易移出队列

        emit CancelTransaction(txHash, target, value, signature, data, executeTime);
    }
    
    function executeTransaction(address target, //执行特定交易
    uint256 value,
    string memory signature,
    bytes memory data,
    uint256 executeTime
    ) public payable onlyOwner returns(bytes memory)
    
    bytes32 txHash = getTxHash(target, value,signature, data, executeTime);
    
    
    require(queuedTransactions[txHash], "Timelock::cancelTransaction: Transaction hasn't been queued.");
    // 检查：交易是否在时间锁队列中
    
    require(getBlockTimestamp() >= executeTime, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
    // 检查：达到交易的执行时间
    
    require(getBlockTimestamp <= executeTime + GRACE_PETIOD, "Timelock::executeTransaction: Transaction is stale.");
    queuedTransactions[txHash] = false;// 获取call data
    bytes memory callData;
    if (bytes(signature).length == 0) {
        callData = data;
    } else {
        callData = abi.encodePacked(bytes4(keccak256(bytes(signature))),data);
    }
    (bool success, bytes memory returnData) = target.call{value: value}(callData);
    // 利用call执行交易
    require(success,"Timelock::executeTransaction: Transaction execution reverted.");
    emit ExecuteTransaction(txHash, target, value, signature, data,executeTime);
    return returnData;
}