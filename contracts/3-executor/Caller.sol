// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./Executor.sol";

// import "./Test.sol";

/**
 * @title Caller
 * @author Steve P.
 * @notice is called upon by other contracts, where executor broadcasts tx to the network. Ref: "Scaffold-ETH Challenge 3" as per https://twitter.com/austingriffith/status/1478760480965476352
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it.
 * TODO: sort out my thoughts about this following conversation with DK and post a question or two within the telegram chat or elsewhere.
 */
contract Caller is Executor {
    Executor executor;
    // Test test;
    uint256 number;

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
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    // generate signature (signed tx) in passable format to use with call()
    // @parameter fnDetails to be store(uint256)... unless we can pass in arbitrary contract addresses and their functions and their parameters. I guess, like Manifold, we could create new contracts that end up inheriting executor.sol. They then can conduct whatever crazy functions they want, and then simply use the executor contract (it doesn't even need to be inherited) to carry out the broadcast of the state changes (txs).
    // The executor would whitelist what contracts can call it through the use of a mapping. Hmm, how would that work though? I'm confused because it seems that call{}() can be used on any contract, and any contract can be used as a proxy contract. That can't be true though, it's a security issue. Can you lock off call(). Last question for dave if ppl don't answer in telegram.

    // Could do some fancy gas efficient stuff with doing mapping(uint=>uint) instead of addresses, but doesn't matter for this exercise.
    function hash(string memory fnDetails, uint256 num) public view returns (bytes memory signedHash) {
        bytes memory hexString = abi.encodeWithSignature(fnDetails, num); //you  need to be able to have the respective contract functions in the abi that this contract can access. I think there is a way to instantiate new external contracts so their ABIs are exposed... without inheritance or importing.
        return hexString;
    }

    // simply passes signature to executor contract to broadcast to the network
    function calls(address executorContract, bytes memory signature) public payable {
        executorContract.call(signature);
    }
}
