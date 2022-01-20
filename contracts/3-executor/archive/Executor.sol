// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

/**
 * @title Executor
 * @author Steve P.
 * @notice is called upon by other contracts, where executor broadcasts tx to the network. Ref: "Scaffold-ETH Challenge 3" as per https://twitter.com/austingriffith/status/1478760480965476352
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: You need the Caller.sol address once deployed, and from there, you can use it in whatever function that creates the function hexstring and passes it via the global function call(). See Caller.sol contract.
 * NOTE: From Tweet: A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it. 
 */
contract Executor is Ownable{
    bytes32 passedCallData;

    /* ========== EVENTS ========== */

    // event ExtCall(); // emit when called with external contract function data

    // event ExtReceived(); // emit when receive a msg.call that has no data and thus calls receive()

    // event ExtFallback(); // emit when receive a msg.call that has data and thus activates fallback()

    /* ========== VIEWS ========== */

    /**
     * @notice Returns total wei
     */
    function totalEth() public view returns (uint256 total) {
        return address(this).balance;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(address owner) {
        _transferOwnership(owner); // deployer address is the owner when generating contract, so it is the msg.sender(deployer account) that transfers Ownership to the address I want to be owner.
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice .calls() anything the owner sends it.
     */
    function calls(bytes32 passedCallData) public onlyOwner {
        if (passedCallData != 0x00) {
        address(this).call{value: msg.value}(passedCallData);
        // emit ExtCall();
        }
    }
}
