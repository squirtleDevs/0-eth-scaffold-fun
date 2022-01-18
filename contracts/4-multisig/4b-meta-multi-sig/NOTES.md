# Rough Notes to be Cleaned Up Before Published Gitbook

## Meta-Multi Signature Wallet:

### Primary Objectives:

1. Off-chain signature gathering multisig: using ECDSA hashing functions to create off-chain txs to be then broadcast to network
2. After basic multisig construction, a streaming feature is added where users can withdraw streamed payments to themselves after streaming deadlines have passed (when rewards have been distributed essentially for that time block).

### Extra Notes to Possibly Help in Getting the Most Out of It:

1. Understanding how the EVM works in a more detailed level, that it uses bytecode to communicate between contracts and users... and how our high-level language smart contract writing compiles down to bytecode and has a "home" on the EVM at an ext. contract address where our project's ABI can be found and hooked into.
2. Understanding how to tangibly work with solidity to carry out offchain tx prep and private signing to get signatures of a signed tx.

### Steps that I am Taking

1. 4a: Go through solidity by example, walk through creating the smart contract. Ensure you understand how it works and wrack your brain on recreating it at least once, peaking is fine but if you build it on your own you'll understand it a lot more.
2. 4b: Go through meta-multi-sig example. Repeat method of 1.
3. 4b: Go through README.md of meta-multi-sig example, which will already be set up to be streaming. Go through the streaming part of the contract and understand it well too. Repeat method of 1.
4. Do the side-quests of the README.md: Create a custom signer for your wallet, and integrate MultiSig wallet into other branches (try integrating it with the simpleNFT one for example)

### Questions

_Understanding how to hash transactions in solidity to be served up to be privately signed off-chain or on-chain, and further pushed into a call() from some proxy contract._

1. SideQuest2: is the only way to pass in different ext. contract addresses and thus connect to their inherent function calls... through importing and inheritance? I think it would be few steps... let's say multisig is deployed, then I deploy the new ext contract I want to use the multisig on... well then I would need to deploy another contract that inherits the new staker.sol contract and the multisig contract.
   --> I'm pretty sure there is a better way... if we just have the ext. address, and then create the hash off-chain for a certain function call, wouldn't that just work somehow? It's math. So if we hash a tx, then we privately sign it with a sudo address, then we get everyone to vote for it... then we can carry out the tx through the multisig where the OG tx was signed by the sudo user. So there, we wouldn't need to have the multisig wallet connect to the actual ABI of the external contracts through inheritance or importing.
2. is the `address _to` in transaction hashes actually the external contract address, signifying where to find the ABIs that we are hooking into?
3. If that is how 2. works, then are the fnDetails simply the function name in a string, and the parameters afterward with explicit types declared?

### Next Steps

1. Figure out the finer details of using call() with hexStrings for txs, and ECDSA-made signatures.
2. Add voting to the multi-sig; gut thought is to do it through creating structs and tallying votes per txIndex similar to the solidity by example smart contract. Although with this multi-sig, the signatures are used to assess votes (yes or no). If no signature is submitted then the user did not vote. So I find it odd to implement a vote button at this point with this project the way it is currently designed. Front end, sure.
