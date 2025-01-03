// SPDX-License-identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract VideoNFTPPV is ERC721URIStorage {
    uint public tokenCount;
    uint public itemCount;


    struct Item {
        uint itemId;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }
    event Offered(uint itemId,uint tokenId,uint price,address indexed seller);
    event Purchased(uint itemId,uint tokenId,uint price,address indexed buyer);
    event VideoNftListed(uint tokenId,uint price);

    mapping(uint => Item) public items;
    mapping(uint => uint) public listedItems;
    mapping(uint => mapping(address => bool )) public hasAccessToVideo;


    // init
    constructor() ERC721("VideoNFT","VNFT") {}

    function mint(string memory _tokenURI,uint _price) external returns(uint) {
    tokenCount++;
    itemCount++;

    _safeMint(msg.sender,tokenCount);
    _setTokenURI(tokenCount,_tokenURI);

    items[itemCount] = Item(
        itemCount,
        tokenCount,
        _price,
        payable(msg.sender),
        false   //init this is false
    );

    emit Offered(itemCount,tokenCount,_price,msg.sender);

        listVideoNFT(tokenCount,_price);

    return tokenCount; // this will return the token count;

    }


    function listVideoNFT(uint256 tokenId,uint256 price) public {

        require(ownerOf(tokenId) == msg.sender,"You do not own this nft");
        require(price > 0,"price must be greater than 0");

    listedItems[tokenId] = price;

        emit VideoNftListed(tokenId,price);
}

    function purchaseItem(uint _itemId) external payable {
    uint _totalPrice = getTotalPrice(_itemId);

    Item storage item  = items[_itemId];
    require(_itemId > 0 && _itemId <= itemCount, "Item doesnt exists");
    require(msg.value >= _totalPrice,"Not enough ether to cover the item price");
    require(msg.sender != item.seller,"Seller cannot buy  own item");

    item.seller.transfer(item.price);
    item.sold = true;
    hasAccessToVideo[item.tokenId][msg.sender] = true;

    emit Purchased(_itemId,item.tokenId,item.price,msg.sender);

    }

    function getTotalPrice(uint _itemId) view public returns(uint) {
        return (items[_itemId].price *(100+3)/100);

    }

    function hasPurchased(uint256 tokenId,address user) external view returns(bool) {
        return hasAccessToVideo[tokenId][user];
}


}
