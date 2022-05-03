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

contract ChilliNft is ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    using ECDSA for bytes32;
    using Strings for uint256;

    Counters.Counter public tokenSupply;
    bool public mintActive = true;

    uint256 public constant MAX_CAP = 999;

    struct TokenIds {
        uint256 count;
        uint256[] tokenIds;
    }

    mapping (address => TokenIds) internal _tokenIdsOfHolder;

    constructor() ERC721("ChilliNft", "CHL") {}

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    function mint(
        address recipient,
        string memory tokenURI,
    ) public onlyOwner nonReentrant returns (uint256) {
        require(mintActive, "Minting is not allowed.");
        require(
            tokenSupply.current().add(1) <= MAX_CAP,
            "This mint would exceed max cap"
        );
        tokenSupply.increment();

        uint256 newTokenId = tokenSupply.current();
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        return newTokenId;
    }

    function setMintActive(bool _active) external onlyOwner {
        mintActive = _active;
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )override internal virtual {}

}
