// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CrowdFunding {
    error Crowd_Funding_Closed();
    error Transfer_Failed();

    address public immutable beneficiary;
    uint256 public immutable fundingGoal;
    uint256 public fundingAmount;

    mapping(address => uint256) public funders;
    mapping(address => uint8) private fundersInserted;
    address[] public fundersKey;

    uint8 public AVAILABLED = 1;

    constructor(address _beneficiary, uint256 _goal) {
        beneficiary = _beneficiary;
        fundingGoal = _goal;
    }

    function contribute() external payable {
        if (AVAILABLED == 0) {
            revert Crowd_Funding_Closed();
        }

        uint256 newAmount = fundingAmount + msg.value;
        if (newAmount > fundingGoal) {
            uint256 refundAmount = newAmount - fundingGoal;
            uint256 contribution = msg.value - refundAmount;

            fundingAmount += contribution;
            funders[msg.sender] += contribution;

            if (fundersInserted[msg.sender] == 0) {
                fundersInserted[msg.sender] = 1;
                fundersKey.push(msg.sender);
            }

            if (refundAmount > 0) {
                (bool success,) = payable(msg.sender).call{value: refundAmount}("");
                if (!success) revert Transfer_Failed();
            }
        }
    }

    function closed() external returns (bool) {
        if (fundingAmount < fundingGoal) {
            return false;
        }

        AVAILABLED = 0;
        uint256 amount = fundingAmount;
        fundingAmount = 0;
        (bool success,) = payable(beneficiary).call{value: amount}("");
        if (!success) {
            revert Transfer_Failed();
        }
        return success;
    }

    function funderLength() public view returns (uint256) {
        return fundersKey.length;
    }
}
