//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IERC1155.sol";

interface IERC1155MetadataURI is IERC1155 {
    function uri(uint256 id) external view returns (string memory);
//IERC1155的可选口 加入uri（）函数查询元数据
}