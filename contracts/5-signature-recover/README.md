\*Make sure you understand how signed messages work and how you can recover them in a smart contract: https://github.com/scaffold-eth/scaffold-eth-examples/tree/signature-recover

# ⚔️ Quest

Below are the steps to the quest that I carried out, hopefully it results in max learning!

1. Go through the README.md with the scaffold-eth branch to get an understanding of what is happening.
   > Note that understanding what is going on behind the scenes is important! See ETH.BUILD videos from Austin Griffith Youtube Channel if you're confused!
2. If confused, see metatransaction video from Austin: https://www.youtube.com/watch?v=CbbcISQvy1E&t=445s, and maybe my comments in the YourContract.sol file will help too.
3. Stub out how the contract should look, and then recreate it from scratch.
4. Deploy it, and test the following:

- Does the contract let you send transactions if you're not the owner? (You should have gone through the whole README.md from the official scaffold-eth example). Why not?
  > <details markdown='1'><summary>Answer</summary> The function uses ECDSA.recover to see who the original signer of the message being sent was. As a main point of this challenge, one observes how the signer's public address can be obtained using the message and the hexstring as inputs due to the hashing nature of the ethereum blockchain. There is a require(owner) essentially, so only the owner of the contract can send txs. </details>
- Can you define each of the parameters that you see in the debug page when you deploy the contract provided by scaffold-eth examples?
  > <details markdown='1'><summary>Answer</summary> 
  > General: see comments in contract. 
  > `getHash()`: encodePacks the details of the transfer tx (from, nonce, to, value). It seems that the signed message triggers the `fallback()` since it doesn't specify function signature within its parameters.
  > Hash of a msg call is a hexstring. Remember that.
  > `metaSendValue()`: generate hash to tx, check that it is the signer using recover(), use call(){}("") to send monies. 
  > **QUESTION 1:** with passing in calldata in a msg call that is signed by someone already, could you just use call() and fill in the ("") with the calldata hexstring or something? That way you are calling the tx. The `to` here in line 42 would simply be whoever is getting the resultant ether. The msg.sender is the one paying for the gas of this msg call (Transaction). **So this contract shows some pieces of how to do executor.sol but you need to know how to instigate passed along, compiled and hashed function calls (calldata), in a proxy contract.**
  > **QUESTION 2:** for a contract to act as a proxy contract and execute a signed tx, does the function that is being transacted have to be inherited, imported, or neither? Pretty much how does the abi work in the high-level coding language of solidity?
  >  </details>
- How would you use this in the executor.sol challenge, where the executor.sol contract has to be able to send out any arbitrary function (message call) given to it using `calls()`
  > <details markdown='1'><summary>Answer</summary> Using `recover()` function to ensure that only certified users and external contract use `call()` within `calls()`. 
  > Have `caller.sol` encodePack (hash) transactions within function `transact()`, where users can input similar msg details as here, but also include bytes32 data which includes call data generate from calling another function from a different contract. It doesn't have to use the bytes32 data, but I think if there isn't any data, then it will go to `fallback()`.   </details>
- How would you limit the usage of executor.sol, and any external contract you create, for arbitrary function calls? Is .call() a universal function that can be called by any ext contract or user anytime? Or does it have to be implemented within a function within the contract in question?
  > <details markdown='1'><summary>Answer</summary> I believe that call() has to be implemented within a function within the last contract if one wants to use that last contract as a proxy. Otherwise when a contract is accessed using `call`, it will go to the `fallback()` and `fallback()` has a limit of 2300 gwei for simply sending tokens, so even if there was `data` within the msg call, it would not be transacted and the whole thing would revert I think because it is not high enough gas to transact!  </details>
