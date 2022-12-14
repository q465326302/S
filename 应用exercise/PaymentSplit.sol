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
        //为有效受益人地址_account分帐，相应的ETH直接发送到受益人地址。
        //任何人都可以触发这个函数，但钱会打给account地址。
        require(shares[_account] > 0,"paymentsplitter:account has no shares");
        //account必须是受益人
        uint256 payment = releasable(_account);
        //计算account应得的eth
        require(payment != 0, "Paymentsplitter: account is not due payment");
        totalReleased += payment;
         // 更新总支付totalReleased和支付给每个受益人的金额released
        released[_account] += payment;
        _account.transfer(payment);//转账
        emit PaymentReleased(_account,payment);
    }
    function releasable(address _account) public view returns (uint256) {
        uint256 totalReleased = address(this).balance + totalReleased;
        return pendingPayment(_account, totalReleased, released[_account]);
        //调用_pendingPayment计算account应得的ETH
    }
    //计算一个账号能分的eth
    function pendingPayment(
        //计算受益人应分的eth
        address _account,
        //受益人地址
        uint256 _totalReceived,
        //分账合约总收入
        uint256 _alreadyReleased
        //该地址已领
    ) public view returns(uint256){
        return (_totalReceived * shares[_account]) / totalShares - _alreadyReleased;
        //account的eth=总应得-已领
    }
    function _addPayee(address _account, uint256 _accountShares ) private {//新增受益人函数
        require(_account != address(0),"PaymentSplitter : account is the zero address");
        //检查——account不为0
        require(_accountShares > 0, "PaymentSplitter : shares are 0 ");
        //检查——accountshares不为0
        require(shares[_account] == 0, "PaymentSplitter: account already has shares");
        //检查——account不重复
        payees.push(_account);
        shares[_account] = _accountShares;
        totalShares += _accountShares;
    //更新pauees、shares、totalsheres
        emit PayeeAdded(_account,_accountShares);
    }
}
    