// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ETHWallet {
    error NOT_OWNER();

    address payable immutable owner;

    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    function withdraw1() external {
        if (owner != msg.sender) {
            revert NOT_OWNER();
        }
        (bool success,) = payable(msg.sender).call{value: 100}("");
        require(success, "Transfer failed");
    }

    function withdraw2() external {
        if (owner != msg.sender) {
            revert NOT_OWNER();
        }
        bool success = payable(msg.sender).send(100);
        require(success, "Transfer Failed");
    }

    function withdraw3() external {
        if (owner != msg.sender) {
            revert NOT_OWNER();
        }
        payable(msg.sender).transfer(100);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
