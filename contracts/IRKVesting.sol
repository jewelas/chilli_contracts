// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRKVesting {
    function  Month () external view returns(uint256);

    function getMonth (uint256 time) external view returns (uint256);

    function quarterVestingAmount (uint256 quarter) external view returns (uint256);
}