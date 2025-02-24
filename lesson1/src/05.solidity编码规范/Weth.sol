// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Weth {
    // errors
    error Insufficient_Value();
    error Insufficient_Balance();
    error Insufficient_Allowance();
    error TransferFailed(address recipient, uint256 amount);
    error InvalidSpender();
    error InvalidUser();
    error Value_More_Than_Zero();

    // state variables

    uint256 supply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public constant NAME = "Wrapped ETH";
    string public constant SYMBOL = "WETH";

    // events
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    modifier moreThanZero(uint256 value) {
        if (value == 0) {
            revert Value_More_Than_Zero();
        }
        _;
    }

    function deposit() public payable moreThanZero(msg.value) {
        balanceOf[msg.sender] += msg.value;
        supply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable moreThanZero(amount) {
        if (amount > balanceOf[msg.sender]) revert Insufficient_Balance();
        
        // 1. Effects (update state)
        balanceOf[msg.sender] -= amount;
        supply -= amount;
        
        // 2. Emit event
        emit Withdrawal(msg.sender, amount);
        
        // 3. Interactions (external call)
        (bool success,) = msg.sender.call{value: amount}("");
        if (!success) revert TransferFailed(msg.sender, amount);
    }

    function approve(address spender, uint256 amount) public moreThanZero(amount) returns (bool) {
        if (spender == address(0)) revert InvalidSpender();
        if (amount > balanceOf[msg.sender]) revert Insufficient_Balance();
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function transfer(address user, uint256 amount) public moreThanZero(amount) returns (bool) {
        if (user == address(0)) revert InvalidUser();
        return transferFrom(msg.sender, user, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public moreThanZero(amount) returns (bool) {
        if (amount > balanceOf[from]) revert Insufficient_Balance();
        if (from != msg.sender) {
            if (amount > allowance[from][to]) revert Insufficient_Allowance();
            allowance[from][to] -= amount;
        }

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function totalSupply() public view returns (uint256) {
        return supply;
    }
}
