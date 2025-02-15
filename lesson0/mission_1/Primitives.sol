// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Primitives {
    bool public boo = true;
    uint8 public u8 = 1;
    uint256 public u256 = 256;

    // negative
    int8 public i8 = 127;
    int256 public i256 = 1999;
    int256 public n_i256 = -1999;
    int256 public maxInt = type(int256).max;
    int256 public minInt = type(int256).min;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    bytes1 a = 0xb5;
    bytes1 b = 0x56;

    bool public defaultBoo;
    uint256 public defaultUint;
    uint256 public defaultInt;
    address public defaultAddr;
}