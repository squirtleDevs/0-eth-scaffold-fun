# Notes from Going Through this Challenge

### Links

1. github README.md that I found to be the most recent version of this challenge: https://github.com/scaffold-eth/scaffold-eth/tree/image-upload-ipfs

### Approach

**`yarn install` doesn't seem to work for some reason! --> got this error `error An unexpected error occurred: "Commit hash required".`**

This challenge hasn't been finalized on eth-dev-speedrun just yet, so I did the following to ensure I understood it well enough:

1. Go through the README.md of the feature branch.
2. Take notes on aspects of it and highlight questions that you need answered to fully-comprehend the topic.
3. Come back to this after a couple of days and write it on your own without looking at the code.

### Notes

**Example IPFS Feature Branch First**

_Medium Blog Post: https://medium.com/@austin_48503/tl-dr-scaffold-eth-ipfs-20fa35b11c35_
_Youtube speed run on example: https://www.youtube.com/watch?v=FEhDyDDOR3g&ab_channel=NickWhite_
_Github: https://github.com/scaffold-eth/scaffold-eth-examples/blob/ipfs-example/packages/buidler/contracts/Attestor.sol_

1. IPFS very helpful for storing dApps on a decentralized network.
2. API for IPFS = simple: bring it in, attatch to pending server (using infura here) --> tracks files using content addresses. Each file has a fingerprint (hash). More uploaders of the file are essentially the servers of the content, so when folks search up the corresponding hash using IPFS they get the file quicker.
3. We enter data which we then upload to IPFS and get the IPFS Hash. We then store that in the next step!
4. The example contract for IPFS from scaffold-eth takes the content-derived hash and stores it within its smart contract through a mapping. Why is this necessary? I guess the example dApp spits out the hash associated to an address, of which the front-end picks it up and de-hashes it show the data content.
5. Basically this contract as a storage for the IPFS hashes for a mapping of different addresses.

**Cheat Sheet**

All in `buidler/react-app/src/App.js`

1. Connecting to IPFS: `const ipfsAPI = require('ipfs-http-lient');`
2. Connecting to Infura: `const ipfs = ipfsAPI({host: 'ipfs.infura.io', port: '5001', protocol: 'https'})`
3. See helper functions: `addToIPFS` and `getFromIPFS`

### Lessons

1. Understanding how to add and get content to IPFS. Similar to Web2, there is a process in which the referenced data is stored using AWS or some other provider (similar to creating your own website pretty much). Alternative options that are more sensorship-resistant are covered though too: a. uploading to IPFS directly and using hooks to the IPFS API that allows "getting" of the content. b.) This branch introduces a third method. Here we allow the user to upload an image from their device right into the app. Two methods are presented for tackling this scenario. The first is a traditional AWS remote server setup which is detailed below. The second is a direct upload to IPFS option. Here image files can be uploaded to IPFS from a react app. This is useful for the various 'NFT creator' apps, allowing for more flexible image generation.
2. I think it's good to know how to do each of these methods, as uploading a project's work in a decentralized way will be more and more attractive. It is secondary to smart contract lessons though at the moment, but will be on the test! **Look through README.md for instructions to study!**
