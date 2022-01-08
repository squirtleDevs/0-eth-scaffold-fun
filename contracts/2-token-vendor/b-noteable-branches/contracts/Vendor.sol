pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";


/**
 * @title Vendor
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 2" as per https://speedrunethereum.com/challenge/token-vendor
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: Deployer contract on rinkeby (showing txs for the two contracts here on testnet rinkeby etherscan): <insert addr>
 * NOTE: Challenge scope is as per the challenge instructions outlined in README.md

 TODO: - [ ] Should we disable the `owner` withdraw to keep liquidity in the `Vendor`?
- [ ] It would be a good idea to display Sell Token Events. Create the `event` and `emit` in your `Vendor.sol` and look at `buyTokensEvents` in your `App.jsx` for an example of how to update your frontend.
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


  // ToDo: create a payable buyTokens() function:
  function buyTokens() external payable {
    uint256 amount = msg.value * tokensPerEth; 
    address payable user = payable(msg.sender);
    yourToken.transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
    
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw(uint256 withdrawAmount) external onlyOwner {
    address payable user = payable(msg.sender);
    user.transfer(withdrawAmount);
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 theAmount) external {
    yourToken.transferFrom(msg.sender, address(this), theAmount);
    address payable user = payable(msg.sender);
    uint256 ethSale = theAmount / tokensPerEth;
    user.transfer(ethSale);
    // emit TokensSold(msg.sender, theAmount, msg.value);
  }

}
