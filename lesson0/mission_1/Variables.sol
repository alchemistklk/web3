// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Variables {
    // state
    string public text = "hello";
    uint256 public num = 123;

    // local variable
    function doSomething() public view returns (uint256, uint256, address) {
        uint256 i = 456;
        uint256 timestamp = block.timestamp;
        address addr = msg.sender;

        return (i, timestamp, addr);
    }
}
