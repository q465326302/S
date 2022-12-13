//SPDX-License-Identifier:MIT
//auther:0xAA
//original contract on ETH: https://rinkeby.etherscan.io/token/0xc778417e063141139fce010982780140aa0cd5ab?a=0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2#code

pragma solidity ^0.8.0;
import "./ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed dst, uint wad);//存款
    event Withrawal(address indexed src, uint wad);//取款

    constructor() ERC20("WERH","WETH"){
//初始化ERC20的名字和代号
    }
    fallback() external payable{
        deposit();
    }
    receive() external payable{
        deposit();
    }
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender,msg.value);
    }//存款函数 存ETH 铸造等量WETH
    function withdraw(uint amount) public {
        require(balanceOf(msg.sender) >= amount );
        _burn(msg.sender,amount);
        payable(msg.sender).transfer(amount);
        emit Withrawal(msg.sender,amount);
    }//提款函数 销毁WETH 取回等量ETH

}