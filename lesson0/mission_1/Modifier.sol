// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FunctionModifier {
    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not Valid Address");
        _;
    }

    function changeOwner(address _addr) public onlyOwner validAddress(_addr) {
        owner = _addr;
    }

    modifier noReentrancy() {
        require(!locked, "Not reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function decrement(uint256 i) public noReentrancy {
        i -= 1;
        if (i > 1) {
            decrement(i);
        }
    }
}
