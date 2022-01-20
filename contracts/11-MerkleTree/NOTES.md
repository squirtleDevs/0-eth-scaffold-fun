# Notes from Going Through this Challenge

### Links

1. github README.md that I found to be the most recent version of this challenge: https://github.com/scaffold-eth/scaffold-eth/tree/merkler
2. Youtube speed run of it(about 60% into the video after the loogies!): https://www.youtube.com/watch?v=mnErFJwujSg&t=1760s&ab_channel=AustinGriffith
3. Video on using several different methods to do an airdrop from openzeppelin: https://www.youtube.com/watch?v=SF-XOwWIwRo&ab_channel=OpenZeppelin
4. Very good youtube video breaking down Merkle Trees (10 minutes): https://www.youtube.com/watch?v=YIc6MNfv5iQ&t=1s&ab_channel=CodingTech

### Approach

This challenge hasn't been finalized on eth-dev-speedrun just yet, so I did the following to ensure I understood it well enough:

1. Go through the README.md of the feature branch.
2. Take notes on aspects of it and highlight questions that you need answered to fully-comprehend the topic.
3. Come back to this after a couple of days and write it on your own without looking at the code.

### Keep in Mind

## **NOTES**

Sending digital assets to a large number of addresses is an interesting challenge. Gas costs, limits, are among some of the things to consider when sending large airdrops because sending one tx at a time or in batches is not a viable option. Enter Merkle trees! You can use merkle trees to create an airdrop to a list of tokens stored OFF-CHAIN that are then validated ON-CHAIN. Hashing that occurs within a merkle tree provide unique, 1-way encryption that is always the same length (I think 32 bytes, but don't quote me).

Let's break down the definition of Merkle Tree from Wikipedia:

> In cryptography and computer science, a hash tree or Merkle tree is a tree in which every leaf node is labelled with the cryptographic hash of a data block, and every non-leaf node is labelled with the cryptogrpahic hash of the labels of its child nodes. Hash trees allow efficient and secure verification of the contents of large data structures.

So leaf nodes are the hash of the concatenated hashes of data blocks (the txs that are being submitted by miners to be included into the network). Non-leaf nodes, or parent nodes, are the hash of the concatenated hashes from the leaf nodes. Through this derivation, they are "stamped" with the leaf node encrypted hash (this helps with partial verification). Finally, the parent nodes continue to combine in new hashes, and finally reach the root hash. The root hash is all that is needed from a trusted party. So when someone wants to verify, they

### Lessons

1.

sppokyswap, beethoven, etc.
