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
        require(_payees.length == _shares.length, "PaymentSplitter: payees and shares length mismatch");
        require(_payees.length > 0, "PaymentSplitter:no payees");
        for (uint256 i = 0; i < _payees.length; i++){
            _addPayee(_payees[i], _shares[i]);
        }
    }