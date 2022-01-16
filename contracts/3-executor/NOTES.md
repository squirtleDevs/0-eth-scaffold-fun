# Helpful Notes (Hopefully)

From Austin Griffith's tweetstorm: "A quick jumping off point is building an "executor" smart contract that just .calls() anything the owner sends it.
This will test your knowledge of calldata and you should go all the way to mainnet with it."

This little tweet led me down a 🐇🕳 but was really great to ensure I understood calldata. I feel that it is something fundamental that is easy to glaze over (seeing as I have written some smart contracts for several months).

_tldr of general lessons learnt:_

> Recall: when a user calls a function in an ext. contract, and the contract itself, within that same function, sends the tx... then the user calling the contract effectively:

1. private signs the tx,
2. pays for the tx in gas (msg.value),
3. gave the details for the tx (whatever the function needed to transact: arguments perhaps) --> which then get encoded into hexstring with the first two bytes of the hexstring being the function signature,
4. state change occurs to the EVM requiring the sent tx.

> The neat part is that you can use a proxy to send the tx, and to pay for the tx, but you sign it. You do that by passing the function hexstring to the function `call()` in a proxy contract and have it carry out the function for you. \*I believe you use `encode`, not `encodepacked` as that is not universal way of passing calldata between contracts?

---

## How to Go About It

Having some "fuzzy" base knowledge of blockchain basics, opcodes, and whatnot, the following really helped me in understanding more under the hood!

Going through this material helped me understand these main take-aways:

1. How crypto-backed transactions were composed of tx details signed by a private key, and furthermore hashed to be picked up by those supporting the blockchain.
2. How merkle trees are used as one of the fundamental building blocks of blockchain models.
   > Understanding 1 & 2, sending a msg.call, and thus a signed message, with calldata to an external smart contract makes more sense. Running theory _atm_ is:
   >
   > 1. **Caller.sol**: Create a function that does this: obtain a hexstring for a tx (within which are the details of function call, etc.) through using `encode` or something like that. Within the same function that just did the encoding, that hexstring is passed to another ext. contract **(Executor.sol)** via a function call, `calls(bytes32 data)` that uses `.call()` to carry out the tx!
   > 2. **Executor.sol**: Create a function `calls(bytes32 data)` that implements any function passed to it. This function makes **Executor.sol** a proxy contract effectively. It will send transactions to the mempool to be further mined into the blockchain! _Caller.sol will be the signer of the calldata, but executor is the one that paid for it._
   >
   > To me this feels like someone signing an agreement and then having their business partners deliver it on their behalf. You have a messenger, and one behind the scenes actually carry out the order.
3. If the above was confusing, understanding the following is good: how high-level smart contract language boils down to machine code, therefore the hexstrings are kind of how ext contracts can universally communicate to each other. I sort of gleaned this stuff by going through the videos and reading below may help!

Once you go have grasped the above, then writing the smart contracts hopefully will be more straight forward. This side-quest from 🏃🏻‍♂️ eth-dev-speedrun is a nice way to test out deploying your own smart contracts with the scaffold-eth front end.

Recall:
ABI is the binary interface that is generated when you compile your smart contracts. It is typically located in a subdirectory "artifacts" for the respective project. When you import libraries (other contracts), or inherit them, do you then get access to their contract addresses and their ABIs? AKA, can I just supply a hash for a tx
How to import ABI to frontend?

1. Copy and Paste the API into the

---

## Some Recommended Reading / Viewing BeforeHand

### 📺 YouTube:

Really great video on Merkle Trees: https://www.youtube.com/watch?v=YIc6MNfv5iQ&ab_channel=CodingTech

Austin Griffith ETH.BUILD videos series: Here's the first and last one, watch all in between IMO.
https://www.youtube.com/watch?v=QJ010l-pBpE&ab_channel=AustinGriffith
https://www.youtube.com/watch?v=-6aYBdnJ-nM&ab_channel=AustinGriffith

A deeper dive into the EVM (I found it helpful to really imprint how the calldata was broken down in a sense): https://www.youtube.com/watch?v=RxL_1AfV7N4&t=2359s&ab_channel=EthereumEngineeringGroup

### 📚 Reading

Anatomy of smart contracts: https://ethereum.org/en/developers/docs/smart-contracts/anatomy/

A breakdown of the EVM: https://ethereum.org/en/developers/docs/evm/

An example of using low-level calls to call other functions in external contracts: https://medium.com/@houzier.saurav/calling-functions-of-other-contracts-on-solidity-9c80eed05e0f

---

## 💪🏼 Clean Thoughts on How to Carry Out Challenge

> Please note that the steps outlined below can be reduced to a few steps once you understand how call() and passing calldata in a `message call` truly works. I have a bunch of questions in it that are hopefully answered if I carry out the below code tasks.

1. Set up `executor.sol` contract with a `calls(bytes32 data)` function that carries out the function call associated to `data`.
2. Set up another contract `caller.sol` that has a function that passes calldata to `calls()` within `executor.sol`.
3. Go through the numerous test cases to see how the EVM will respond once the code is compiled and you attempt to interact with it as a user within debug tab.
4. Test case 1: see what happens when you attempt to carry out the global functions: `send()`, `transfer()`, `call()`
5. Test case 2: see what happens when you attempt to encode a custom function in a different contract. Contract #3: `test.sol` Let's say, `sum() public returns (uint256)` where there are local variables in `sum`: uint256 sum = 7+35; returns sum; --> Within `caller.sol`, write a new function `test2`: instantiate bytes32 data, and implement code that calls `test.sol` and encodes its function `sum()` to bytes32 data. Pass `data` to `caller.sol` by writing something like: `caller.call{value: <ethamount>, <gasAmount>}(data)` --> what happens?
6. Test case 3: see what happens when you do test case 2 but with a function that has parameters. Back in `test.sol`, write a function `sumNum(uint256 x, uint256 y) public returns (uint256 sum)` that sums up both x and y. Do the same thing as test case 2 but with `sumNum` --> how does it differ from the result you get at the end of test case 2?
7. Test case 4: see what happens if you write implementation code in `executor.sol` within `calls()` where you implement `onlyOwner` from Openzeppelin. This would be pretty important I think. **This test will show whether or not there needs to be implementation code within an ext. contract for it to _receive and execute_ calldata carrying function signatures in it** If onlyOwner revert occurs when you run the tests, then I guess that means you could access it normally with an external contract, but if you implement onlyOwner then nope! Which is good. This is the hopeful result.
8. Finale: Can you get the bytes32 data for any public or external function call in any external contract that exists on a: A.) testnet or B.) your local hardhat network node? You would have to publish your contract to etherscan, get the bytes32 calldata for the respective function, pass it into your `executor.sol` contract, and voila! Either it works or doesn't :)
