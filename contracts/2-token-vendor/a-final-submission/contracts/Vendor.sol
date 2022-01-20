pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

/**
 * @title Vendor
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 2" as per https://speedrunethereum.com/challenge/token-vendor
 * NOTE: Challenge scope is as per the challenge instructions outlined in README.md
 * NOTE: I chose to not disable the owner ability to withdraw from the Vendor, although I understand that it would be ideal for an automated, 24/7 vending machine!
 */
contract Vendor is Ownable {
    YourToken yourToken;
    uint256 public constant tokensPerEth = 100;

    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when tokens are purchased
     */
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    /**
     * @notice Emitted when tokens are purchased
     */
    event TokensSold(address seller, uint256 amountOfTokens, uint256 amountOfEth);

    constructor(address tokenAddress) public {
        yourToken = YourToken(tokenAddress);
    }

    /**
     * @notice allows user to buy tokens (GLD) for a set amount of ETH per token
     */
    function buyTokens() external payable {
        uint256 amount = msg.value * tokensPerEth;
        address payable user = payable(msg.sender);
        yourToken.transfer(msg.sender, amount);
        emit BuyTokens(msg.sender, msg.value, amount);
    }

    /**
     * @notice owner can withdraw eth from this contract
     */
    function withdraw(uint256 withdrawAmount) external onlyOwner {
        address payable user = payable(msg.sender);
        user.transfer(withdrawAmount);
    }

    /**
     * @notice sells users tokens for ETH from vendor.sol
     */
    function sellTokens(uint256 theAmount) external {
        yourToken.transferFrom(msg.sender, address(this), theAmount);
        address payable user = payable(msg.sender);
        uint256 ethSale = theAmount / tokensPerEth;
        user.transfer(ethSale);
        emit TokensSold(msg.sender, theAmount, ethSale);
    }
}
