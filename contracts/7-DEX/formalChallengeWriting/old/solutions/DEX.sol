pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/**
 * @notice this is a single token pair reserves DEX
 */
contract DEX {

  IERC20 token;

  constructor(address token_addr) {
    token = IERC20(token_addr); // SP: this allows this contract to connect with the ABI of token using the IERC20 interface.
  }

  uint256 public totalLiquidity; // total liquidity of the contract for Balloons
mapping (address => uint256) public liquidity; // This line in specific ensures that we know how much liquidity is in each user, in this case the msg.sender!

  /**
  * @notice load the contract up with both ETH and Balloons
  */
  function init(uint256 tokens) public payable returns (uint256) {
      require(totalLiquidity==0, "DEX: init - already has liquidity");
      totalLiquidity = address(this).balance;
      liquidity[msg.sender] = totalLiquidity; // this line and the one above is to prevent re-entrancy attacks. 
      require(token.transferFrom(msg.sender, address(this), tokens));
      return totalLiquidity;
    }

  /**
   * @notice price calculated based off of x * y = k
   */
  function price(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) public view returns (uint256) {
    uint256 input_amount_with_fee = input_amount.mul(997);
    uint256 numerator = input_amount_with_fee.mul(output_reserve);
    uint256 denominator = input_reserve.mul(1000).add(input_amount_with_fee);
    return numerator / denominator;
  } 

  /**
   * @notice ethToToken calculates amount of output asset using price function viewing ratio of reserves vs input asset
   */
   function ethToToken() public payable returns (uint256) {
     uint256 token_reserve = token.balanceOf(address(this));
     uint256 tokens_bought = price(msg.value, address(this).balance.sub(msg.value), token_reserve);
     require(token.transfer(msg.sender, tokens_bought));
     return tokens_bought;
   }

  /**
   * @notice ethToToken calculates amount of output asset using price function viewing ratio of reserves vs input asset
   */
   function tokenToEth(uint256 tokens) public returns (uint256) {
     uint256 token_reserve = token.balanceOf(address(this));
     uint256 eth_bought = price(tokens, token_reserve, address(this).balance);
     msg.sender.transfer(eth_bought);
     require(token.transferFrom(msg.sender, address(this), tokens));
     return eth_bought;
   }

  /**
   * @notice deposit allows anyone to contribute to liquidity
   */
   function deposit() public payable returns (uint256) {
     uint256 eth_reserve = address(this).balance.sub(msg.value);
     uint256 token_reserve = token.balanceOf(address(This));
     uint256 token_amount = (msg.value.mul(token_reserve) / eth_reserve).add(1);
     uint256 liquidity_minted = msg.value.mul(totalLiquidity) / eth_reserve;
     liquidity[msg.sender] = liquidity[msg.sender].add(liquidity_minted);
     totalLiquidity = totalLiquidity.add(liquidity_minted);
     require(token.transferFrom(msg.sender, address(this), token_amount));
     return liquidity_minted;
   }


  /**
   * @notice withdraw allows LP to withdraw their contribution to contract liquidity
   */
   function withrdaw(uint256 amount) public returns (uint256, uint256) {
     uint256 token_reserve = token.balanceOf(address(this));
     uint256 eth_amount = amount.mul(address(this).balance) / totalLiquidity;
     uint256 token_amount = amount.mul(token_reserve) / totalLiquidity;
     liquiditypmsg.sender] = liquidity[msg.sender].sub(eth_amount);
     totalLiquidity = totalLiquidity.sub(eth_amount);
     msg.sender.transfer(eth_amount);
     require(token.transfer(msg.sender, token_amount));
     return (eth_amount, token_amount);
   }
}