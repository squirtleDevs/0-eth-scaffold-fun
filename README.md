# 🏗 scaffold-eth | 🏰 BuidlGuidl

## 🚩 Purpose of this Repo

> 🙋🏻‍♂️ Smart Contracts for Scaffold-ETH will be stored within this open repo for future reference. Note that the contracts are stored here to show:

1. The final submission for that challenge.
2. Possible areas of study that I found noteable for the future (in their own NOTES.md files, respectively).

> The two aspects above are stored in respective sub-directories for each project. NOTE: Of course, these are just the raw smart contract files, so the necessary dependencies will be needed and whatnot. Consider these contracts just a reference, not an easily fork-able and deploy-able repo.
> vhttps://github.com/squirtleDevs/0-eth-scaffold-fun
> Each project is submitted through the telegram and other communications methods outlined by Austin Griffith, if possible, and contracts are deployed typically on Rinkeby. Rinkeby addresses are to be stored in the Details.md for each project.

---

### My Interpretation of the Curriculum

> The Ethereum Speed Run (July 30, 2021) and Austin Griffith's (@austingriffith)'s tweetstorm (January 5th, 2022) are what I reference for how I will go about learning with scaffold-eth.

1. Ethereum Speed Run: https://medium.com/@austin_48503/%EF%B8%8Fethereum-dev-speed-run-bd72bcba6a4c
2. AustinGriffith Tweetstorm: https://twitter.com/austingriffith/status/1478760479275175940?s=20

**NOTE: It seems that there are two pointers for Scaffold-Eth Challenge material:**

1. Most (if not all challenges outlined in Austin's tweetstorm): https://github.com/scaffold-eth/scaffold-eth-examples/tree/master
2. Official Scaffold-Eth github repo that has the experimental goodness: https://github.com/scaffold-eth/scaffold-eth

---

> _Below is the combined curriculum taking into account these two points of reference (there was a lot of overlap!). NOTE: I think I will have NOTES.md for each challenge that outline what was learnt, questions on the topics, good resources._

1. Scaffold-ETH challenges: simple NFT, staking app, token vendor.

2. THEORY HEAVY (if you're new): A quick jumping off point is building an “executor” smart contract that just .calls() anything the owner sends it. This will test your knowledge of calldata and you should go all the way to mainnet with it.

3. 👛 Next, build your own multisig using this as a reference: https://solidity-by-example.org/app/multi-sig-wallet/

\*Make sure you understand how signed messages work and how you can recover them in a smart contract: https://github.com/scaffold-eth/scaffold-eth-examples/tree/signature-recover

- 🧑‍🏭 \*Learn how signed messages can be used off-chain as a “sign in with Ethereum”: https://github.com/scaffold-eth/scaffold-eth-examples/tree/sign-in-with-web3
- 📡 Use that same signed message on-chain with ecrecover() or OpenZeppelin’s ECDSA lib to recover a signed message in Solidity: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol

Try building a signature based multisig: https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig

⚔️ \*Side Quest: Extend it into a ⏳ streaming multi-sig: https://github.com/scaffold-eth/scaffold-eth-examples/tree/streaming-meta-multi-sig
👩‍👩‍👧‍👧 Extend the mult-sig branch and create a DAO where members “vote” on proposed transactions!

4. Make sure you understand how LP tokens work.

Use this MVP DEX article to create a smart contract that will swap tokens and ETH: https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90

PRO TIP, use a master branch of 🏗 scaffold-eth so you have all the latest goodies: https://github.com/scaffold-eth/scaffold-eth

5. Develop your skills and get in the habit of deploying prototypes and small tools/dashboards to fit your own needs.

Web3 Twitter is really useful for getting new information and spreading awareness about what you are building.

6. SVG NFT

7. Build an NFT with a price curve

8. Make sure you're solid on IPFS: https://github.com/scaffold-eth/scaffold-eth/tree/image-upload-ipfs 8. Build and understand a merkle tree distribution: https://github.com/scaffold-eth/scaffold-eth-examples/tree/merkler

9. Build on ZK: https://twitter.com/austingriffith/status/1478051900255653889

10. Dice game, attack dice game, build a testnet casino, build simple Keno game using future block hash: https://twitter.com/austingriffith/status/1478760491858083841

11. Build a tx indexer: https://twitter.com/austingriffith/status/1478760493661646850

12. Underflow, commit/reveal, diamond standard upgrade pattern: https://twitter.com/austingriffith/status/1478760495431622659

13. DelegateCall(), Proxy Factories, Minting NFTs on other networks: https://twitter.com/austingriffith/status/1478760497503637505

14. Token Gating/Enabling, https://twitter.com/austingriffith/status/1478760499579797515

15. NFTs: https://twitter.com/austingriffith/status/1478760501538557952
    🟢 Fork this SVG NFT and make your own… check out the SVG and JSON getting rendered by this smart contract: https://github.com/scaffold-eth/scaffold-eth/blob/loogies-svg-nft/packages/hardhat/contracts/YourCollectible.sol#L100

16. Sending ETH from a contract, understanding the Graph, creating mempool dashboard: https://twitter.com/austingriffith/status/1478760503623045120

17. Attacks, lending, and leverage: https://twitter.com/austingriffith/status/1478760505716011011
    🔭 Study the hacks on solidity-by-example and try to reproduce them locally.

18. Gnosis safe starter kit, bounty creation: https://twitter.com/austingriffith/status/1478760507762876416

19. Different versions of scaffold-eth: https://twitter.com/austingriffith/status/1478760509402873857

20. Stuff that wasn't mentioned in tweetstorm but is in the July 2021 speed run:
    - 🐸 You can use an “oracle” to provide randomness and external data too: https://github.com/austintgriffith/scaffold-eth/tree/chainlink-tutorial-1
    - ⚔️ Side Quest: deep dive bonding curves for ERC20s: https://github.com/austintgriffith/scaffold-eth/tree/bonding-curve
    - 👉 Try out this <Swap/> tutorial where we build a Uniswap interface: https://azfuller20.medium.com/swap-with-uniswap-wip-f15923349b3d
    - 💸 Lending is critical to DeFi. Tinker with the <Lend/> component: https://azfuller20.medium.com/lend-with-aave-v2-20bacceedade
    - 🦍 Ape into learning! https://azfuller20.medium.com/aave-ape-with-%EF%B8%8F-scaffold-eth-c687874c079e
    - ✍️ Fork signator.io from the source code here: https://github.com/scaffold-eth/scaffold-eth/tree/signatorio
    - 🎨 Fork nifty.ink from the source code here: https://github.com/BuidlGuidl/nifty-ink
