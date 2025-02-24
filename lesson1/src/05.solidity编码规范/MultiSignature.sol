// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MultiSignature {
    error Owner_Required();
    error Required_Number_Valid();
    error Invalid_Owner();
    error Repeated_Owner();

    mapping(address => bool) public isOwner;
    address[] public owners;
    uint256 public required;

    struct Transaction {
        address to; // 20 bytes
        uint256 value; // 32 bytes
        bool executed; // 1 byte
        bytes data; // 32+ bytes (动态大小，新存储槽)
    }

    Transaction[] public transactions;
    // record every owner's attitude, pass or no pass
    mapping(uint256 => mapping(address => bool)) public approved;

    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Approved(address indexed approver, uint256 txId);
    event Execute(uint256 indexed _txId);
    event Revoke(address indexed sender, uint256 _txId);

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier notApproved(uint256 _txId) {
        require(approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "tx is executed");
        _;
    }

    modifier txExisted(uint256 _txId) {
        require(_txId < transactions.length, "tx is invalid");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(owners.length > 0, "owner required");
        require(_required > 0 && _required <= owners.length, "invalid number of owner");
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            // valid the owner
            if (owner == address(0)) {
                revert Invalid_Owner();
            }
            // If the user is repeated, revert error
            if (!isOwner[owner]) {
                isOwner[owner] = true;
                owners.push(owner);
            } else {
                revert Repeated_Owner();
            }
        }
        required = _required;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function submit(address _to, uint256 _value, bytes calldata _data) external onlyOwner returns (uint256) {
        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false}));
        emit Submit(transactions.length - 1);
        return transactions.length - 1;
    }

    function approve(uint256 _txId) external onlyOwner txExisted(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approved(msg.sender, _txId);
    }

    function execute(uint256 _txId) external onlyOwner txExisted(_txId) notExecuted(_txId) {
        require(getApproveCount(_txId) >= required, "approve count is not enough");
        Transaction storage t = transactions[_txId];

        t.executed = true;
        (bool success,) = t.to.call{value: t.value}("");
        require(success, "Transfer Failed");
        emit Execute(_txId);
    }

    function getApproveCount(uint256 _txId) private view returns (uint256) {
        uint256 count;
        uint256 len = owners.length;
        unchecked {
            for (uint256 i; i < len; ++i) {
                count += approved[_txId][owners[i]] ? 1 : 0;
            }
        }
        return count;
    }

    function revoke(uint256 _txId) external onlyOwner txExisted(_txId) notExecuted(_txId) {
        require(approved[_txId][msg.sender], "tx is not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}
