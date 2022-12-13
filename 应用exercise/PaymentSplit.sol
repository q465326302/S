// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract PaymentSplit{
    event PayeeAdded(address account, uint256 shares); // 增加受益人
    event PaymentReleased(address to, uint256 amount); // 受益人提款
    event PaymentReceived(address from, uint256 amount); // 合约收款

    uint256 public totalShares; // 总份额
    uint256 public totalReleased; // 总支付

    mapping(address => uint256) public shares; // 每个受益人的份额
    mapping(address => uint256) public released; // 支付给每个受益人的金额
    address[] public payees; // 受益人数组
    
    constructor(address[] memory _payees, uint256[] memory _shares) payable {
        //检查_payees和_shares数组长度相同，且不为0
        require(_payees.length == _shares.length, "PaymentSplitter: payees and shares length mismatch");
        require(_payees.length > 0, "PaymentSplitter:no payees");
        //调用_addPayee,更新受益人地址payees、受益人份额shares总份额totalshares
        for (uint256 i = 0; i < _payees.length; i++){
            _addPayee(_payees[i], _shares[i]);
        }
        //初始化受益人和分账份额数组，要求数组长度不为0，数组长度相等 
        //_shares中元素要大于0，_payees中地址不能为0地址且不能有重复地址

    }
    receive() external payable virtual {
        emit PaymentReceived(msg.sender,msg.value);
    }
    function release(address payable _account) public virtual {
        //account必须是受益人
        require(shares[_account] > 0,"paymentsplitter:account has no shares");
        //计算account应得的eth
        uint256 payment = releasable(_account);
        require(payment != 0, "Paymentsplitter: account is not due payment");
        totalReleased += payment;
        released[_account] += payment;
        _account.transfer(payment);
        emit PaymentReleased(_account,payment);
    }