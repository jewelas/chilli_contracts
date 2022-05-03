//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
interface ISeductions{
    function isInWhiteList (address addr) external view returns(bool);

    function getChickTraitofTokenId(uint256 tokenId) external view returns(uint256);

    function burn(uint256 tokenId) external;

    function checkChickTraitCount (address holder, uint256 trait) external view returns(bool);

    function ownerOf(uint256 tokenId) external view returns (address);
}