

// Let's create an multi-sig wallet. Here are the specifications.

// The wallet owners can

// submit a transaction
// approve and revoke approval of pending transcations
// anyone can execute a transcation after enough owners has approved it.

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// // import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
// import "./ExampleExternalContract.sol";

/**
 * @title SimpleMultiSig
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 4" as per https://twitter.com/austingriffith/status/1478760482710327296
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: Next, build your own multisig using this as a reference: https://solidity-by-example.org/app/multi-sig-wallet/

 */
contract SimpleMultiSig {
    bytes32 passedCallData;

    /**
     * I think I will build it by first answering these questions:
     * How does a wallet work currently? It is a public half of the hashing function or whatever where the owner has the private key. In smart contract format, the wallet sends msg.call to a contract function, which could just be msg.value and the signature of the respective wallet. By default I think that all EVM compatible wallets and external contracts have the ability to interact with one another as long as there is enough ETH within each respective wallet. 
     * So each ext contract can call a function from another contract by being imported into a metamask... hmm and then somehow seeking approval at the same time of a tx without it becoming stale? Perhaps somehow it gets the function signature and generates the bytecode (encodepacked) to 32 bytes and presents that to the ext contract through call()
     * OK so it is a bit confusing how to specify a function call, get approval from the suers, the proceed with it without becoming stale.
     * I guess the details that are part of the trade or whatever are not necesasrily finite in expiration time. If I want to trade x tokens for y tokens on uniswap, I put those values in and see what I get - I guess it is actually more that I put in a tokens and get however many b tokens the protocol provides me as a result of slippage and the overall trading ratio.
     * So with that you could just connect like a metamask and interact with a dApp, call the function, be the msg.sender. In that case, you need approval from all the signers before the tx can go through. TBH having trouble envisioning what to do!
     * OK, what about the other parts of the equation... approve and revoke approval of pending txs. somehow before it is mined into a block, the revoking of a tx can occur within the multisig itself. Perhaps a function has bytes32 for itself... and it seeks approval so owners vote on that respective data. Have a submit vote function where users can vote on a new proposed data (tx) with yes or no. They are default no, and the record for the respective owner gets recorded in a mapping as true or false. Have a for loop that checks the bool for each user, and then talies them up. For the amount of users in the array (that way we can measure the length), we will assess the bools vs the length/2 to ensure majority. We could have other types of requirements instead of 51% or so, but that could be defined in just extra rules that would be adopted by the base voting mechanics.
     * So the tx is voted in, there is an execute() function that any owner can call. It executes the .call with the respective bytesdata that is associated to an external function call for a unique contract? 
     */

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

    constructor() {}

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice collect funds and track individual 'balances' with a mapping
     */
    function calls(bytes32 passedCallData) public {
        // emit ExtCall();
    }
}
