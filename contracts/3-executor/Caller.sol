// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./Executor.sol";
import "./Test.sol";

/**
 * @title Caller
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 3" as per https://twitter.com/austingriffith/status/1478760480965476352
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it. See NOTES.md for my thoughts on how to tackle this.
 */
contract Caller {
    Executor executor;
    Test test;

    bytes32 passedCallData;

    /* ========== VIEWS ========== */

    /**
     * @notice Returns total wei
     */
    function totalEth() public view returns (uint256 total) {
        return address(this).balance;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(address executorAddr, address testAddr) {
        executor = Executor(executorAddr);
        test = Test(testAddr);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice
     */
    function test1(bytes32 passedCallData) public {
        exampleExternalContract.complete{ value: address(this).balance }();
        bytes32 memory passedCallData = encodePacked(); // TODO: look up right way to do encodePacked and pass calldata.

        // emit ExtCall();
    }
}
