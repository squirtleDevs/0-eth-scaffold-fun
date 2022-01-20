pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

/**
 * @title YourToken
 * @author Steve P.
 * @notice Simple YourToken.sol contract used in "Scaffold-ETH Challenge 2" as per https://speedrunethereum.com/challenge/token-vendor
 * NOTE: Challenge scope is as per the challenge instructions outlined in README.md
 */
contract YourToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Gold", "GLD") {
        // uint256 initialSupply = 1000;
        _mint(msg.sender, initialSupply);
    }
}
