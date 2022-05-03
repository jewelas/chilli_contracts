//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Seductions is ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using ECDSA for bytes32;
    using Strings for uint256;

    Counters.Counter public tokenSupply;
    Counters.Counter public whiteListCount;
    bool public mintActive = true;
    bool public saleActive = false;
    bool public whiteListSaleActive = false;

    uint256 public constant MAX_SEDUCTIONS = 999;
    uint256 public constant MAX_SEDUCTIONS_SALE_CAP = 10;
    uint256 public constant SEDUCTIONS_FOR_WAIFU = 3;

    mapping(uint256 => uint256) private chickTraitofTokenId;
    mapping(address => uint256) private addressSaleCount;
    mapping(address => uint256) private whiteListIndexOfUser;
    mapping(uint256 => address) private userOfWhiteListIndex;

    constructor() ERC721("Seductions", "SDT") {}

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    function mintSeduction(
        address recipient,
        string memory tokenURI,
        uint256 trait
    ) public onlyOwner nonReentrant returns (uint256) {
        require(mintActive, "Minting is not allowed.");
        require(
            tokenSupply.current().add(1) <= MAX_SEDUCTIONS,
            "This mint would exceed max supply of Seductions"
        );
        tokenSupply.increment();

        uint256 newTokenId = tokenSupply.current();
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        chickTraitofTokenId[newTokenId] = trait;

        return newTokenId;
    }

    function sale(
        uint256 tokenId
    ) external payable nonReentrant {
        if(whiteListSaleActive) {
            require(isInWhiteList(_msgSender()), "Sale for only WhiteList Clients.");
        }else{
            require(saleActive, "Sale is not active.");
        }
        require(ownerOf(tokenId) == owner(), "Invalid token for sale.");
        require(addressSaleCount[_msgSender()].add(1) <= MAX_SEDUCTIONS_SALE_CAP, "You can only mint a maximum of 10 for sale");
        safeTransferFrom(owner(), _msgSender(), tokenId);
        addressSaleCount[_msgSender()] += 1;
    }

    function checkChickTraitCount (address holder, uint256 trait) external view returns(bool){
        uint256 count = 0;
        if(balanceOf(holder) < SEDUCTIONS_FOR_WAIFU) return false;
        for (uint256 i = 1; i <= tokenSupply.current(); i ++) {
            if(ownerOf(i) == holder && chickTraitofTokenId[i] == trait) {
                count++;
            }
        }
        if(count < SEDUCTIONS_FOR_WAIFU) return false;
        else return true;

    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )override internal virtual {
        require((saleActive && from == owner()) || !saleActive, "Invalid Transfer Call!");
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
    }

    function addToWhiteList(address[] memory users) public onlyOwner{
        for(uint256 i=0; i<users.length; i++){
            _addToWhiteList(users[i]);
        }
    }

    function removeFromWhiteList(address[] memory users) public onlyOwner{
        for(uint256 i=0; i<users.length; i++){
            _removeFromWhiteList(users[i]);
        }
    }

    function _addToWhiteList (address user) internal onlyOwner {
        if(!isInWhiteList(user)) {
            whiteListCount.increment();
            userOfWhiteListIndex[whiteListCount.current()] = user;
            whiteListIndexOfUser[user] = whiteListCount.current();
        }
    }

    function _removeFromWhiteList (address user) internal onlyOwner {
        if(isInWhiteList(user)){
            whiteListCount.decrement();
            userOfWhiteListIndex[whiteListCount.current()] = user;
            uint256 index = whiteListIndexOfUser[user];
            delete whiteListIndexOfUser[user];
            delete userOfWhiteListIndex[index];
        }
    }

    function isInWhiteList (address addr) public view returns(bool){
        if(whiteListIndexOfUser[addr] > 0) return true;
        else return false;
    }

    function getChickTraitofTokenId(uint256 tokenId) external view returns(uint256) {
        return chickTraitofTokenId[tokenId];
    }

    function setMintActive(bool _active) external onlyOwner {
        mintActive = _active;
    }

    function setSaleActive(bool _active) external onlyOwner {
        saleActive = _active;
    }

    function setWhiteListSaleActive(bool _active) external onlyOwner {
        whiteListSaleActive = _active;
    }

}
