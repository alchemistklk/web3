// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SavingOffice {
    error NotOwner();
    error ContractDestroyed();
    error NoETHAvailable();
    error NoTokensAvailable();
    error NotNFTOwner();
    error TransferFailed();

    address payable public immutable owner;
    bool public isDestroyed;

    event Deposit(address indexed user, uint256 indexed amount);
    event Withdraw(address indexed user, uint256 value);
    event TokenWithdraw(address indexed contAddress, address indexed user, uint256 amount);
    event NFTWithdrawn(address indexed _addr, address indexed user, uint256 tokenId);

    using SafeERC20 for IERC20;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier notDestroyed() {
        if (isDestroyed) revert ContractDestroyed();
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance <= 0.01 ether) revert NoETHAvailable();

        isDestroyed = true;

        (bool success,) = owner.call{value: balance}("");
        if (!success) revert TransferFailed();

        emit Withdraw(msg.sender, balance);
    }

    function withdrawToken(address tokenAddress) external onlyOwner notDestroyed {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        if (balance == 0) revert NoTokensAvailable();

        token.safeTransfer(owner, balance);
        emit TokenWithdraw(tokenAddress, owner, balance);
    }

    function with721Token(address nftAddress, uint256 tokenId) external onlyOwner notDestroyed {
        IERC721 nft = IERC721(nftAddress);
        if (nft.ownerOf(tokenId) != address(this)) revert NotNFTOwner();

        nft.safeTransferFrom(address(this), owner, tokenId);
        emit NFTWithdrawn(nftAddress, owner, tokenId);
    }
}
