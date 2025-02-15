// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EtherUtils {
    uint256 public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = (oneWei == 1);

    uint256 public oneGwei = 1 gwei;
    bool public isOneGwei = (oneGwei == 1e9);

    uint256 public oneEther = 1 ether;
    bool public isOneEther = (oneEther == 1e18);
}
