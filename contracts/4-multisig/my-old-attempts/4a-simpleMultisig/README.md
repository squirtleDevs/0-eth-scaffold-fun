Second: Try building a signature based multisig: https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig

⚔️ \*Side Quest: Extend it into a ⏳ streaming multi-sig: https://github.com/scaffold-eth/sc^affold-eth-examples/tree/streaming-meta-multi-sig
👩‍👩‍👧‍👧 Extend the mult-sig branch and create a DAO where members “vote” on proposed transactions!

Welcome to the 👛multisig cohort of the SpeedRunEthereum.com challenges!

You know how to build a basic dapp with a smart contract, you’ve tackled the DEX…

This ⛳ challenge is to create your own multisig and deploy it to a live network with a frontend.

🤔 I would grab a master branch of 🏗scaffold-eth and then cherry pick from this branch: https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig

🚸 WARNING: there are some weird things in this branch that you don’t need like the transferFunds (instead of just sending value in the call) So the UI even has some extra weirdness.

⚽️ GOALS 🥅

[ ] can you edit and deploy the contract with a 2/3 multisig with two of your addresses and the buidlguidl multisig as the third signer? (buidlguidl.eth is like your backup recovery.)

[ ] can you propose basic transactions with the frontend that sends them to the backend?

[ ] can you “vote” on the transaction as other signers?

[ ] can you execute the transaction and does it do the right thing?

[ ] can you add and remove signers with a custom dialog (that just sends you to the create transaction dialog with the correct calldata)

[ ] BONUS: for contributing back to the challenges and making components out of these UI elements that can go back to master or be forked to make a formal challenge

[ ] BONUS: multisig as a service! Create a deploy button with a copy paste dialog for sharing so _anyone_ can make a multisig at your url with your frontend

[ ] BONUS: testing lol

🧪 This build will require a good knowledge of signed messages and you can get a refresher here: https://github.com/scaffold-eth/scaffold-eth-examples/tree/signature-recover

---

## TODO:

- [ ] Outline smart contract and function details within an interface
- [ ] Review interface with actual solidity by example and compare
- [ ] Review design spec for the multi-sigs as per the challenge (streaming, non-streaming, signature-based)
- [ ] Go through the github repo from past challenge write-up; see the README.md and add to what you think should be added so far. Add to it as you go afterwards.
- [ ] Write the multisig contracts finally
- [ ] Get the front-end to work with the multisigs
- [ ] Deploy, finalize README.md
- [ ] Work on streaming multi-sig as feature-branch.
- [ ] Write new article for it to show how to make it extending off of the last multisig contract

---

## TODO: Research to Check Out

After reviewing †he design spec again:

- My old erc721middleman code for how to use hashing functions with ethersJS
  https://github.com/umphams/erc721Middleman/blob/c3ee1f432c13b598657eaf8aad4a67e34b03d597/test/helpers.test.js#L58
- Reading up on hashing functions with ethersJS and how it would work with the multisig --> we would need to generate function hashes offline to pass into the multisig! https://docs.ethers.io/v5/api/utils/hashing/
- https://stackoverflow.com/questions/69127399/how-to-call-external-contract-with-abi-encodewithsignature-with-no-arguments

Project 4a: Simple Multisig from Solidity by Example

👛 Next, build your own multisig using this as a reference: https://solidity-by-example.org/app/multi-sig-wallet/

// submit a transaction
// approve and revoke approval of pending transcations
// anyone can execute a transcation after enough owners has approved it.

- NOTE: A multisig is simply an ext. contract that carries out function calls on behalf of a group of stakeholders (users). Txs are proposed, they are assessed, and carried out if they are approved. If they are not approved, the record of the proposal is still kept on-chain, but if ppl want to propose the same tx, they'll need to submit a new Tx with the same details.

Notes before really diving into solidity by example:

Feature 1: Create a multisig where I can specify: # of signers, their addresses, n/m requirement for voting successful proposals --> Method: constructor() specifying all details. Multisig is its own deployed contract, and it contains: an array or mapping (going array) of signers, struct array of Txs with properties [bytes txHexstring, bytes32 signature, address to, address from, uint256 value, bool approvedOrNot]
Feature 2: Create a proposed Tx to be assessed by everyone else. Pass in address of ext. contract (if using one), and then the function details (parameters, and function). Get the hash of the Tx. Pass that hash along to the Tx struct array, as well as a bunch of other info (who proposed it, value). Propose a timeline too (deadline for when the tx will switch to rejected if not enough ppl vote).
Feature 3: Assess a proposed Tx - require(msg.sender == approvedSigners), and also allow approvedSigners to submit their vote. Votes for a proposed tx are accounted for by incrementing a `approve` or `reject` counter within the respective struct. I think it can be in a mapping(signers=>bool result) signerVotes; Where we can use a for loop on the signer of signers[] and change the signerVotes mapping for signers[i]. As well, we can have a simple uint256 counter within the function that tallies up approves and assesses it against the requiredAmountofVotes uint256. Depending on the result, the tx is approved or not. If it is rejected, set the state to rejected. I will implement a requirement that proposals are not rejected or successful when calling `assess()`
Feature 4: Execute the function. require(approved == true), have the whole (bool success, bytes calldata) be a return from using the call() from the multisig! This way we private sign the proposed Tx, and we pass it along as the multisig ext address!
Feature 5: Change n/m whenever you want, but only for proposals that have yet to be proposed. This also has the requirement of needing approved voting.
Feature 6: removeSigner() --> use array.pop and get rid of a signer, change the n/m as well if desired. Requires a vote though to do this.

---

# Parts to Include in Cleaned-Up Repo

After taking a look at the smart contracts, a couple of notes:

- Use of arrays in combination with mappings seem to be a systematic pattern that pops up in more and more smart contracts.
- Understanding these patterns is advantageous, when someone comes out needing a new smart contract, I think it would prove very fruitful to understand patterns commonly used and why.
- Arrays used to store the keys, and then using said keys to find data in mappings is a common pattern.

> We see that with how the multisig contract has an array of addresses as owners, and uses those addresses in a mapping as the keys to get further data (isOwner where they find out if the bool is true or false). Thinking about this further... we can see how using mappings and known keys is far more efficient than looping through the array.

> Another common pattern is to use an array of data to create a loop to populate a mapping for that respective data array (keys). Understanding these core elements of solidity is quite important: https://www.devtwins.com/blog/understanding-mapping-vs-array-in-solidity

> Testing the call{}() function to see if it actually works with the data tx seen in the multisig solidity by example contract. Doing the test in remix.

---

Up Next:

Try building a signature based multisig: https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig

*⚔️ \*Side Quest: Extend it into a ⏳ streaming multi-sig: https://github.com/scaffold-eth/scaffold-eth-examples/tree/streaming-meta-multi-sig
*👩‍👩‍👧‍👧 Extend the mult-sig branch and create a DAO where members “vote” on proposed transactions!\_

---

Rough Notes Before Looking Over Solidity by Example:

/\*\*
_ I think I will build it by first answering these questions:
_ How does a wallet work currently? It is a public half of the hashing function or whatever where the owner has the private key. In smart contract format, the wallet sends msg.call to a contract function, which could just be msg.value and the signature of the respective wallet. By default I think that all EVM compatible wallets and external contracts have the ability to interact with one another as long as there is enough ETH within each respective wallet.
_ So each ext contract can call a function from another contract by being imported into a metamask... hmm and then somehow seeking approval at the same time of a tx without it becoming stale? Perhaps somehow it gets the function signature and generates the bytecode (encodepacked) to 32 bytes and presents that to the ext contract through call()
_ OK so it is a bit confusing how to specify a function call, get approval from the suers, the proceed with it without becoming stale.
_ I guess the details that are part of the trade or whatever are not necesasrily finite in expiration time. If I want to trade x tokens for y tokens on uniswap, I put those values in and see what I get - I guess it is actually more that I put in a tokens and get however many b tokens the protocol provides me as a result of slippage and the overall trading ratio.
_ So with that you could just connect like a metamask and interact with a dApp, call the function, be the msg.sender. In that case, you need approval from all the signers before the tx can go through. TBH having trouble envisioning what to do!
_ OK, what about the other parts of the equation... approve and revoke approval of pending txs. somehow before it is mined into a block, the revoking of a tx can occur within the multisig itself. Perhaps a function has bytes32 for itself... and it seeks approval so owners vote on that respective data. Have a submit vote function where users can vote on a new proposed data (tx) with yes or no. They are default no, and the record for the respective owner gets recorded in a mapping as true or false. Have a for loop that checks the bool for each user, and then talies them up. For the amount of users in the array (that way we can measure the length), we will assess the bools vs the length/2 to ensure majority. We could have other types of requirements instead of 51% or so, but that could be defined in just extra rules that would be adopted by the base voting mechanics.
_ So the tx is voted in, there is an execute() function that any owner can call. It executes the .call with the respective bytesdata that is associated to an external function call for a unique contract?
\*/
