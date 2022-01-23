Use this MVP DEX article to create a smart contract that will swap tokens and ETH: https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90

PRO TIP, use a master branch of 🏗 scaffold-eth so you have all the latest goodies: https://github.com/scaffold-eth/scaffold-eth

---

# Notes from Going Through this Challenge

These are just my thoughts on how to structure this challenge formally. We are getting into more complicated concepts with smart contracts. Coding meets Economics. This format emphasizes learners to work with a generic design spec, and learn through working through it. Therefore the steps are:

1. Review design spec.
2. Outline an interface, and thus function high-level details, that covers the architecture of the contracts to be written.
3. Can refer to this README.md where each step of the interface is a section. Each section breaks into: a description of the feature, context for those new to the DEX feature concept, a toggle showing a hint, goals to help guide the learner to checking for needed aspects, finally the solution for that section.

Actually, looking at what is written so far in the README.md, I think a lot of good is there... so I'll just adjust wording to further challenge the learner.

### Links

1. Medium post: https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90
2. github README.md that I found to be the most recent version of this challenge: https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-5-dex
3. Youtube speed run of it: https://www.youtube.com/watch?v=eP5w6Ger1EQ&t=364s&ab_channel=SimplyExplained

### Approach

This challenge hasn't been finalized on eth-dev-speedrun just yet, so I did the following to ensure I understood it well enough:

1. Go through medium post and assess each line of code to ensure I understand it (the math side was the most challenging part of this, but if you understand TWAP from Uniswap you'll be able to understand this IMO!).
2. Write the code line by line referencing the medium post.
3. Come back to this after a couple of days and write it on your own without looking at the code.
4. Mark down other notes about this to keep in mind.

### Keep in Mind

1. The front-end aspects were not working just yet due to a bug that needed to be fixed with `AddressInput` on the react side with importing from eth-hooks. So gotta go back and start working with that once I start working on React more.
2. The math side is important to come back to with a pen and paper to make sense of.

---

# Walk-Through from Fork Off of Scaffold-Eth Master Branch

I am going to:

1. Keep in mind checkpoints as I build this.
2. Focus mainly on the solidity code, but I will do the front end stuff as requested using any existing code they have set up (will do react classes and focus on that after getting through the solidity side of things with the scaff eth challenges).

## Start

We are going to focus on creating a simplified DEX. The DEX will be a single-pool. Imagine it was created by the uniswap factory. So you will only have one token-pair within it. Make it ETH and Balloons.

> What contracts do you think we will need?

Answer: You will need a token contract and a DEX contract. The token contract inherits the erc20 standard, and the DEX contract works with it!

Task 1: Create the Balloons contract and mint 1000 Balloons to whatever address deploys it. Do you remember how many sig figs to put into the 1000 amount to work with solidity?

> Trick question: just put `1000 ether`

Task 2: Use the following code blob to start the DEX. Don't skim over the notes though for how it is set up! No one likes underflow/overflow.

```
pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title DEX
 * @author <author>
 * @notice this is a single token pair reserves DEX, ref: "Scaffold-ETH Challenge 2" as per https://speedrunethereum.com/challenge/token-vendor
 * NOTE:
 */
contract DEX {

    using SafeMath for uint256; //outlines use of SafeMath for uint256 variables
    IERC20 token; //instantiates the imported contract

    constructor(address token_addr) public {
        token = IERC20(token_addr); //specifies the token address that will hook into the interface and be used through the variable 'token'
    }

}
```

Then, let’s create an init() function in DEX.sol that is payable and then we can define an amount of tokens that it will transfer to itself. It will initialize the amount of tokens that will be transferred to the DEX itself from the erc20 contract mintee (and only them based on how Balloons.sol is written). Loads contract up with both ETH and Balloons.

> Checkpoint! Write the code yourself and compare to the DEX feature branch. Run `yarn run compile`

Deploy the contracts again.

> Checkpoint!

1. Who has the 1000 balloons when the contracts are freshly deployed? Answer: the msg.sender address. _Change it to the front end address_
2. What are the steps needed for `init` to transact properly? Answer: the front end address needs to approve the transfer of the Balloons from the front end user to the DEX contract that lives at its own external address.

Continue along through the medium blog post, somethings to note though:

1. `deploy.js` file is not what you will work with for deployment edits, it is actually the file: `00_deploy_your_contracts.js` in packages/hardhat/deploy.
2. `dex` is not a recognized variable yet within `00_deploy_your_contracts.js`. You'll need to instantiate it and obtain the Address using `ethers` and `getContract()`.
3. When setting up the `init` automation through your `00_deploy_your_contracts.js` script, make sure to edit the amounts of ether and balloons you are sending through.

> Checkpoint! Do you understand how the x\*y=k price curve actually work? Write down a clear explanation for yourself and derive the formula for price. You might have to shake off some old algebra skills!
> You should be able to go through the price section of this tutorial with the sample numbers and generate the same outputChange variable.

> Hints: See this link, solve for the change in the Output Reserve. Also, don't forget to think about how to implement the trading fee. Solidity doesn't allow for decimals, so one way that contracts are written to implement percentage is using whole uints (997 and 1000) as numerator and denominator factors, respectively.

### Trading

Now, use the price function within two new trading functions: first one is for ethToToken(), second one is tokenToEth().

> Checkpoint! Try everything you can think of swap wise, do the trades make sense?

### Adding Liquidity

> Checkpoint!

1. Deposit liquidity, and then check your liquidity amount through the mapping. Has it changed properly? Did the right amount of assets get deposited?
2. What happens if you deposit(), then another user starts swapping out for most of the balloons, and then you try to withdraw your position as a liquidity provider? Answer: you should get the amount of liquidity proportional to the ratio of assets within the isolated liquidity pool.

###

---

### Quick-Start with Complete Repo

1. ` yarn chain``yarn start``yarn deploy `
2. Should have the front end set up so that it automatically initializes DEX with 5 ETH to 5 Balloons.
