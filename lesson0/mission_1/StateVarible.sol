// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {

    uint256 public nums;

    function set(uint256 _nums) public {
        nums = _nums;
    }

    function get() public view returns (uint256) {
        return nums;
    }
}
