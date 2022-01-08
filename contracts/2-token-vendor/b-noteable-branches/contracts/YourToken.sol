pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    // ToDo: add constructor and mint tokens for deployer,
    //       you can use the above import for ERC20.sol. Read the docs ^^^

     constructor(uint256 initialSupply) public ERC20("Gold", "GLD") {
        // uint256 initialSupply = 1000;
        _mint(msg.sender, initialSupply);
    }
}
