// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

/**
 * @title Executor
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 3" as per https://twitter.com/austingriffith/status/1478760480965476352
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it. See NOTES.md for my thoughts on how to tackle this.
 */
contract Test {
    bytes32 passedCallData;

    /* ========== VIEWS ========== */

    /**
     * @notice Returns total wei
     */
    function totalEth() public view returns (uint256 total) {
        return address(this).balance;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor() {}

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice collect funds and track individual 'balances' with a mapping
     */
    function calls(bytes32 passedCallData) public {
        // emit ExtCall();
    }
}
