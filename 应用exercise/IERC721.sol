//SPDX-Licen-Identifier:MIT

pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address indexed form, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint256 indexed token);
    event ApprovalForAll(address indexed owner,address indexed operator,bool approved);

    function balanceOf(address owner) external view returns(uint256 balanceOf);
    
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address form,
        address to,
        uint256 token,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address form,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address form,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function isApprovedForAll(address owner,address operator) external view returns(bool);
}