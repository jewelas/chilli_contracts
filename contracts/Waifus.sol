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
import './ISeductions.sol';

contract Waifus is ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using ECDSA for bytes32;
    using Strings for uint256;

    Counters.Counter public tokenSupply;
    bool public mintActive = true;
    bool public saleActive = false;
    
    uint256 public constant MAX_WAIFUS = 333;

    mapping(uint256 => uint256) private chickTraitofTokenId;


    ISeductions _seductions;

    constructor(address seductionsAddr) ERC721("Waifus", "WFS") {
        _seductions = ISeductions(seductionsAddr);
    }

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    function mintWaifus(
        address recipient,
        string memory tokenURI,
        uint256 trait
    ) public onlyOwner nonReentrant returns (uint256) {
        require(mintActive, "Minting is not allowed.");
        require(
            tokenSupply.current().add(1) <= MAX_WAIFUS,
            "This mint would exceed max supply of Waifus"
        );
        tokenSupply.increment();

        uint256 newTokenId = tokenSupply.current();
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        chickTraitofTokenId[newTokenId] = trait;

        return newTokenId;
    }

    function sale(
        uint256 tokenId,
        uint256[] memory sdtIds
    ) external nonReentrant {
        require(saleActive, "Sale is not active.");
        require(ownerOf(tokenId) == owner(), "Invalid token for sale.");
        uint256 trait = chickTraitofTokenId[tokenId];
        for(uint256 i=0; i<3; i++) {
            require(_seductions.getChickTraitofTokenId(sdtIds[i]) == trait && _seductions.ownerOf(sdtIds[i]) == _msgSender(), "Not eligible for MetaMarriage with this Chick");
        }
        for(uint256 i=0; i<3; i++){
            _seductions.burn(sdtIds[i]);
        }
        safeTransferFrom(owner(), _msgSender(), tokenId);
    }

    function setMintActive(bool _active) external onlyOwner {
        mintActive = _active;
    }

    function setSaleActive(bool _active) external onlyOwner {
        saleActive = _active;
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
}
