// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

/**
 * @notice Interface of DEX.sol that just outlines what features could be part of the challenge (up to you!)
 * @dev Make sure to create your own DEX.sol file, don't use this IDEX.sol file to launch your contracts!
 */
interface IDEX {
    /**
     * @notice initializes amount of tokens that will be transferred to the DEX itself from the erc20 contract mintee (and only them based on how Balloons.sol is written). Loads contract up with both ETH and Balloons.
     * @param tokens amount to be transferred to DEX
     * @return totalLiquidity is the balance of this DEX contract
     * NOTE: since ratio is 1:1, this is fine to initialize the totalLiquidity (wrt to balloons) as equal to eth balance of contract.
     */
    function init(uint256 tokens) public payable returns (uint256);

    /**
     * @notice returns yOutput, or yDelta for xInput (or xDelta)
     */
    function price(
        uint256 xInput,
        uint256 xReserves,
        uint256 yReserves
    ) public view returns (uint256 yOutput);

    /**
     * @notice sends Ether to DEX in exchange for $BAL
     */
    function ethToToken() public payable returns (uint256 tokenOutput);

    /**
     * @notice sends $BAL tokens to DEX in exchange for Ether
     */
    function tokenToEth(uint256 tokenInput) public returns (uint256 ethOutput);

    /**
     * @notice allows deposits of $BAL and $ETH to liquidity pool
     * NOTE: Ratio needs to be maintained.
     */
    function deposit() public payable returns (uint256 tokensDeposited);

    /**
     * @notice allows withdrawal of $BAL and $ETH from liquidity pool
     */
    function withdraw(uint256 amount) public returns (uint256 eth_amount, uint256 token_amount);
}
