// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./Executor.sol";
import "./Test.sol";

/**
 * @title Caller
 * @author Steve P.
 * @notice is called upon by other contracts, where executor broadcasts tx to the network. Ref: "Scaffold-ETH Challenge 3" as per https://twitter.com/austingriffith/status/1478760480965476352
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it.
 */
contract Caller is Executor {
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

    /**
     * @notice generate a hash for a msg call that a user or ext. contract can privately sign in signedHashedTx()
     * @param fnDetails is simply whatever you have to pass into the function to encode the correct hexString to carry out the respective function!
     */
    function hashTx(string fnDetails) public returns (bytes fnHexString) {
        //insert implementation code
    }

    /**
     * @notice generate a signed tx hash to be passed into executor.sol calls()
     */
    function signHashedTx(string fnDetails) public returns (bytes32 signature) {
        bytes fnHexString = hashTX(fnDetails);
        bytes32 signature = fnHexString;
        return signature;

        // TODO: How do you privately sign a msg so you have a signature to be broadcast to EVM? --> One Hypothesis: You don't need implementation code to sign a tx! I think you generate a signed message simply by connecting your public address account to this contract, at this ext. contract address, and call this function (through the ABI)... since the scope of the variables are local to the function, no state changes. So you just get a mathematical proof of a privately signed piece of data (calldata) which you can pass along to be executed and broadcast to the network if you actually want to change the state!
    }

    /**
     * @notice
     */
    function passHash(string fnDetails) public returns (bool success) {
        bytes32 signature = signHashedTx(fnDetails);
    }
}
