//SPDX-Licen-Identifier:MIF
pragma solidity ^0.8.4;
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./WTFApe.sol";

contract NFTSwap is IERC721Receiver{
    event List(address indexed seller, address indexed nftaddr, uint indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftAddr,uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);
    event Updata(address indexed seller, address indexed nftAddr,uint256 indexed tokenId,uint256 newPrice);

    struct Order{
        address owner;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Order)) public nftList;

    fallback() external payable{}

    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public{
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.getApproved(_tokenId) == address(this),"Need Approval");
        require(_price > 0);
        Order storage _order = nftList[_nftAddr][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;
        _nft.safeTransferFrom(msg.sender, address(this),_tokenId);

        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    function purchase(address _nftAddr, uint256 _tokenId) payable public {
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.price > 0, "invalid Price");
        require(msg.value >= _order.price, "Increase price");

        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order");

        _nft.safeTransferFrom(address(this),msg.sender,_tokenId);
        payable(_order.owner).transfer(_order.price);
        payable(msg.sender).transfer(msg.value-_order.price);
        
        delete nftList[_nftAddr][_tokenId];

        emit Purchase(msg.sender,_nftAddr,_tokenId,msg.value);
    }
    function recoke(address _nftAddr, uint256 _tokenId) public {
        Order storage _order = nftList[_nftAddr][_tokenId];                         
        require(_order.owner == msg.sender, "Not Owner");
        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this),"Inavlid Order");

        _nft.safeTransferFrom(address(this),msg.sender,_tokenId);
        delete nftList[_nftAddr][_tokenId];

        emit Revoke(msg.sender, _nftAddr, _tokenId);
    }
    function Update(address _nftAddr, uint256 _tokenId,uint256 _newPrice) public {
        require(_newPrice > 0,"Invalid Price");
        Order storage _order = nftList[_nftAddr][_tokenId];
        require(_order.owner == msg.sender,"NOt Owner");

        IERC721 _nft = IERC721(_nftAddr);
        require(_nft.ownerOf(_tokenId) == address(this),"Invalid Order");
        
        _order.price = _newPrice;

        emit Updata(msg.sender, _nftAddr, _tokenId ,_newPrice);

    }
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external override returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
    }
}