//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "./IERC165.sol";

interface IERC1155Receiver is IERC165 {
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);
    //单币转账函数，接受ERC1155安全转账safetransferfrom 需实现并返回自己的函数选择器0x623a6e61
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata value,
        bytes calldata data
    ) external returns(bytes4);
    //多币转账接受函数，接受ERC1155安全转账safeBacthtransferfrom 需实现并返回自己的函数选择器0xbc197c81
}