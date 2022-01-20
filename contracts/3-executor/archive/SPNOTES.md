# Steve's Extra Notes

This is just my own notes, more-so for my own reference in the future and comprehension of specific topics.

---

###

Ref: Some Recommended Reading / Viewing BeforeHand outlined in NOTES.md

> My interpretation of this challenge is to understand how to pass calldata into a function within "executor.sol," perhaps even the `fallback` function. So one needs to understand:

- **How the EVM works:** be able to explain it accurately. (hint: EVM uses bytecode, that is obtained from compiling high-level code (solidity, vyper, etc.) --> calldata is in hexadecimal I think... each hex represents 4 bits (nibble), and 8 bits is 2 hex characters (a byte) --> so calldata is in bytes32. Those bytes are used by the EVM).

  **ANSWER:**

  One single entity, maintained by thousands of connected computers running an Ethereum client. The Ethereum protocol exists to keep the continuous, uninterrupted, and immutable operation of this special state machine. The protocol is the environment which all Ethereum accounts and smart contracts live. At whatever block in the chain, there is only one 'canonical' state, and the EVM defines the rules for computing a new valid state from block to block.

  Pre-req info:

  - Merkle Tree: Every leaf is labelled with a cryptographic hash of a data block, and every node that is not a leaf (branch) is labelled with the cryptographic hash of the labels of its child nodes. This format (hash tree) allows efficient and secure verification of contents of a large data structure. Hash tree is a generalization of hash list and hash chain.
    https://en.wikipedia.org/wiki/Merkle_tree

    - https://www.youtube.com/watch?v=YIc6MNfv5iQ&ab_channel=CodingTech
    - Alternatives to host-based addressing (the URL we use is tightly bound to a respective host-base atm), and server-problems (having to use centralized servers via hosting servers): P2P solutions: content addressing (Generating address for a piece of content based on its value) --> crypto hash functions: one way function that takes input (File) and generates a fix-lengthed output (32 bytes typically).
    - Helps solve the other problems: hashes are unique IDs of the content so it is a unique address for that content.
    - Sharing the actual files (splitting dataset into small chunks) amongst a network of computers (where they handle the disk-space (memory), and bandwidth).
    - P2P networks: anonymous and untrusted. So dangerous if you do not verify that the file is the accurate file. Merkle trees save the day.
    - Merkle trees: allow efficient data verification across network of peers. Node store hashes instead of chunks of data. Leaf nodes store hashes of chunks of data. Parent nodes concat the left and right children and apply hash function of the result.
    - Imagine you have 4 chunks of data, determine leaf nodes --> apply hash function to each chunk. Determine parent nodes. Concat hash of 1 and 2 and apply hash function to that result. Do that for B. Then do it for its parent, C (h(A,B)). Call that the root hash.
      ---> Root node, or Root hash. It is important role in peer to peer networks. Merkle tree is really just a representation of datasets. So when you compare two merkle trees you can tell if they're the same or not. Changes in leaf nodes bubble up to the root hash! So we just have to compare the root hash, minimizing the number of comparisons needed.
      - Imagine getting the root hash from a trusted friend, then you start asking peers on the network for files associated to that root hash. You get the files from random people on the network but you don't trust them. You need to verify the data. SO this is the second role that the root hash plays. You can reconstruct the merkle tree with the hash of the functions from the network and see if it comes out as the same root hash.
      - Downloading data from a p2p network comes in sporadic formation. So you cannot download it all at once. You need to verify data as you receive it. So that's why we need to construct a tree: partial verification.
      - Summary: Merkle trees used everywhere. Vital for p2p networks and decentralized systems. Able to address content with root hash means we get consisten lengths no matter where the content is hosted, and we get efficient verification enabling distribution of hosted files. This allows web to be built on small contributions of many rather than the concentrated resources of a few.

**Before I found and watched Austin's ETH.BUILD videos which cleared things wayyyy up**

- Ref: https://www.youtube.com/watch?v=RxL_1AfV7N4&ab_channel=EthereumEngineeringGroup
  The ethereum client is an instance of software running on a node in a network. A client is both the server and the client in the p2p network. It is the machine operating the ethereum network. Recall that in web2, we have servers and clients as separate entities. Clients request data from servers, servers serve it up! For a node on the Ethereum network, they pick up txs containing EVM bytecode and hash it into a block. That block is then corroborated against all other nodes within the network to ensure validity. Then the block is mined, and the network moves the state of the EVM forward to the newest 'canonical' state. Wow.

  Spinning off of that... the smart contracts we write get compiled down to EVM bytecode (recall all that stuff: 2 bytes historically equal a character in the old days, some form of that is true here... but for all intensive purposes, we just know that 32 bytes are created when data is hashed using the hashing function that the EVM expects). The bytecode is made interactive through an ABI file.

  ---> Now if we are dealing with a smart contract that needs another contract yet to be compiled (and thus no interface to work with), then we can leverage the .call() function and pass in the arbitrary bytecode we want to carry out in the OG smart contract. This works because... function bytecode is immutable. The method and the contract it derives from is immutable (one address), so that makes it possible to use .call() if it is available within a contract. --> is .call() available in all deployed smart contracts --> if it were, I would think that is a big risk. I think it is available for transfering of eth... but to accept bytecode that carries out functions? Ooof.

  ---> How could I ensure that call() isn't something you can just call up? I could try setting up a simple smart contract with a hardhat deployed UI with scaffold-eth.

  ----> From there, I could then see if the calls() works without any implementation code written in it. I would test it with global functions (transfer, send, call), and then try an external smart contract function deployed after it (a simple hello world contract).

  ----> hello world contract: 1 implementation with an input, 1 without an input, 1 with 2 inputs. ---> each should generate different EVM bytecode to pass as data to the OG contract.

  My theories going in: I think that if I write two new contract: 1 that creates a function that the OG one should be using but cannot due to immutability, and the other to encode the first function, and then pass the data into the OG contract... then that presents a scenario where one may want to use this. Let's say there is a bunch of ETH in the OG contract... we don't want to let anyone just call transfer and get the ETH out of the contract and send it to them. A way someone would do that is by writing 1 contract to get the encoded function signature for transfering, and another contract to pass the encoded function signature to the OG one. Hmm. But then you could pass a transfer function for all the ETH to a different user from the OG contract! That sounds horrible.

  ----> So I would anticipate that I'm not allowed to do that. I can test it though and see what happens. Alternatively, I ask the group and see their thoughts, and do a general google search.

- **How solidity encodes (encodepacked, etc.) functions with their function data (Arguments, and other details).**

  **ANSWER:**

- Why is it useful that solidity allows encoding?

  **ANSWER:**

- **How is the ABI used in this? What is the purpose of the ABI?**

  **ANSWER:** The ABI allows the frontend to tie into the EVM via the smart contracts interface. ABI = connection between front-end to contract to EVM-compatible bytecode.\*\*

- **So how does passing calldata fit into all this?**

**ANSWER:**
Normally a user or ext. contract calls a function within a smart contract by sending a msg to the contract with calldata outlining the tx details. Which then creates state-changing information, of which is passed along in hex bytecode (hexstring), of which is hashed and passed into the mempool in the EVM. Calldata contains the details of a transaction when dealing with external contracts. There are global functions such as `send()`, `transfer()`, `call()`, that do not require `data` to be passed in the respective message. BUT, for functions written in high-level external smart contracts, `calldata` is necessary. To me it sounds like when someone interacts with an external contract and its function, they are sending a message with details for that function. That function compiles down to bytecode with the information that is passed and creates a respective hexstring.

> If the contract itself, within that same function, sends the tx, then the user calling the contract effectively: 1. private signs the tx, 2. pays for the tx in gas (msg.value), 3. gave the details for the tx (whatever the function needed to transact: arguments perhaps) --> which then get encoded into hexstring with the first two bytes of the hexstring being the function signature, 4. state change occurs to the EVM requiring the sent tx.

> The neat part is that you can use a proxy to send the tx, and to pay for the tx, but you sign it. You do that by passing the function hexstring to the function `call()` in a proxy contract and have it carry out the function for you.

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
