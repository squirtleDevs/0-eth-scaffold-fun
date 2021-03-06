# 🏗 scaffold-eth | 🏰 BuidlGuidl

> an off-chain signature based multi sig wallet

---

## 🚨 STEVE/M00NPAPI/WHOEVER TODO: Aspects to Check Before Finalizing

<details markdown='1'><summary>👨🏻‍🏫 TO DO List</summary>

### Smart Contracts

### UI

### Testing

</details>

---

## 🚩 **Challenge 4: Meta Multi Sig Wallet**

## 👇🏼 Quick Break-Down 👛

This is a smart contract that acts as an off-chain signature-based shared wallet amongst different signers that showcases use of meta-transaction knowledge and ECDSA `recover()`. **If you are looking for the challenge, go to the challenges repo within scaffold-eth!**

> If you are unfamiliar with these concepts, check out all the [ETH.BUILD videos](https://www.youtube.com/watch?v=CbbcISQvy1E&ab_channel=AustinGriffith) by Austin Griffith, especially the Meta Transactions one!

At a high-level, the contract core functions are carried out as follows:

**Off-chain: ⛓🙅🏻‍♂️** - Generation of a packed hash (bytes32) for a function call with specific parameters through a public view function . - It is signed by one of the signers associated to the multisig, and added to an array of signatures (`bytes[] memory signatures`)

**On-Chain: ⛓🙆🏻‍♂️**

- `bytes[] memory signatures` is then passed into `executeTransaction` as well as the necessary info to use `recover()` to obtain the public address that ought to line up with one of the signers of the wallet.
  - This method, plus some conditional logic to avoid any duplicate entries from a single signer, is how votes for a specific transaction (hashed tx) are assessed.
- If it's a success, the tx is passed to the `call(){}` function of the deployed MetaMultiSigWallet contract (this contract), thereby passing the `onlySelf` modifier for any possible calls to internal txs such as (`addSigner()`,`removeSigner()`,`transferFunds()`,`updateSignaturesRequried()`).

**Cool Stuff that is Showcased: 😎**

- NOTE: Showcases how the `call(){}` function is an external call that ought to increase the nonce of an external contract, as [they increment differently](https://ethereum.stackexchange.com/questions/764/do-contracts-also-have-a-nonce) from user accounts.
- Normal internal functions, such as changing the signers, and adding or removing signers, are treated as external function calls when `call()` is used with the respective transaction hash.
- Showcases use of an array (see constructor) populating a mapping to store pertinent information within the deployed smart contract storage location within the EVM in a more efficient manner.

<details markdown='1'><summary>👨🏻‍🏫 Challenge TODO </summary>

# Challenge TODOs From Austin:

Welcome to the 👛multisig cohort of the SpeedRunEthereum.com challenges!

You know how to build a basic dapp with a smart contract, you’ve tackled the DEX…

This ⛳ challenge is to create your own multisig and deploy it to a live network with a frontend.

🤔 I would grab a master branch of 🏗scaffold-eth and then cherry pick from this branch: https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig

🚸 WARNING: there are some weird things in this branch that you don’t need like the transferFunds (instead of just sending value in the call) So the UI even has some extra weirdness.

⚽️ GOALS 🥅

[ ] can you edit and deploy the contract with a 2/3 multisig with two of your addresses and the buidlguidl multisig as the third signer? (buidlguidl.eth is like your backup recovery.) // 🙆🏻‍♂️ Answer: constructor can outline the signatures that are part of the multisig, as well as the signaturesRequired variable.

[ ] can you propose basic transactions with the frontend that sends them to the backend? // 🙆🏻‍♂️ Answer: get encodePacked function calls using the hashFunction() [so tie that to the front end from the smart contract], then take those hashes and send them to the backend where they'll reside in a pool. Those functions will be privately signed off-chain in the backend. Front end prompts users to sign them, user signs them, then a signature is stored in the backend data array bytes[].

[ ] can you “vote” on the transaction as other signers? // 🙆🏻‍♂️ Answer: Yes, if you have the private keys to the signer account. You would sign the tx on the front-end, talking to the backend that has the tx hash, which generates a signature and pushes it to a bytes[] in the backend to be pushed to the smart contracts when calling executeTransaction().

[ ] can you execute the transaction and does it do the right thing? // 🙆🏻‍♂️ Answer: As long as it has the votes and the right inputs! Be careful about nonces.

[ ] can you add and remove signers with a custom dialog (that just sends you to the create transaction dialog with the correct calldata) // 🙆🏻‍♂️ Answer: Add buttons in the front-end for add-signer and remove-signer. Have those tie back to either a back-end or the smart contract ABI where it can get the function call hash as a bytes32 variable with the specific parameters of `add-signer()`, `remove-signer()`, `updateSignaturesRequired()`.

### 🚨 Extra as of Jan 31, 2021:

[ ] Getting multiple signers together to send eth out of the multisig // Answer: implement transfer() to send ether out.

But once you can make a transaction then you start to get into the territory of having the multisig interact with dapps and how you craft that calldata

[ ] For instance what if you want your multisig to swap ETH to DAI using uniswap

(A secret move here is using wallet connect and there is an example of this in the punk wallet.) // _Answer: I'm not sure what wallect connect is used for here. We just need the uniswap external contract address to line it up on our hardhat local network. And then we'll get the function signature by hashing the params and function name for the swap on uniswap. - From there we'd just put in the same components that pre-exist for the other two functions (add and remove signers) in order to produce a signed transaction (aka a voted YES for tx)._

(You wallet connect into uniswap _as_ your multisig and do the swap in the UI and then it proposes the swap back to your multisig)

[ ] BONUS: for contributing back to the challenges and making components out of these UI elements that can go back to master or be forked to make a formal challenge // 🙆🏻‍♂️ Answer: so create component files for this challenge that can be used!

## Bringing in an External Contract and Creating a tx from it

### Theory:

In order to call a function from an external contract using a multi-sig, the following steps are carried out (whether you know it or not):

1. Empty transaction details are prepared and hashed. This is done through collecting the proper function name, and the parameters that are needed for the function call, and hashing those details to produce a hexstring, or hash in the form of `bytes`, let's call it `calldata`.
2. Stage the `calldata` within the multisig by hashing the multisig nonce, any ether value that may be sent with the tx to whatever contract that being interacted with, and the address of the user. What is happening here? You have now staged the full unsigned transaction in a bytes32 hash. A metaphor I like to use is that in step 1, you were making a cake. In this step, you're putting that cake in a box to be ready to be signed for and sent out to your favorite fren. This all happens in `getTransactionHash()`
3. Sign the final transaction hash using ethersJS. Luckily for us, it is already taken care of within the frontend and backend in this framework from scaffold-eth. It is important to understand what is happening though, and how to actually set this up yourself using `Provider.sign()`, etc.

If you're starting from scratch with this repo, then you'll have to uncomment some things. Let's go one step further though, if you're starting from scratch from the meta-multi-sig scaffold-eth-example branch, then we can talk about what steps we'll take to set up the buttons and backend to get the signed swap tx that will end up calling a local copy of the deployed uniswap v2 on our local hardhat network.

NOTE: really, we could set up a separate typescript or javascript file that uses EthersJS and carries out step 2 above, completely outside of this whole scaffold-eth framework. We could then pass that `bytes signature` to the multisig to be voted on and executed.

### Steps

Since we want a similar UX as for the other functions within our contract, we're going to use the DAI details that can be found in app.jsx to start:

Let's start at the top. You're going to have to go to `./constants` based off of this and define new variables for the external address you're dealing with. In our case, we're working with Uniswap, so we'll need all pertinent details of Uniswap here.

Placeholder DAI details:
`import { INFURA_ID, DAI_ADDRESS, DAI_ABI, NETWORK, NETWORKS } from "./constants";`

Revised Uniswap details:
`import { INFURA_ID, UNISWAP_ETHDAI_ADDRESS, UNI_ABI, NETWORK, NETWORKS } from "./constants";`

Within `./constants` we'll have these constants defined:

`export const UNIROUTER_ADDRESS = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";`

- external address for the UniswapV2Router02.sol deployed.

The ABI for the router, under: `export const UNIROUTER_ABI = ...`

> That sets up the importing and constants needed to even start accessing the external contract for uniswap router, and thus swapping.

Now, find the DAI line of code to bring in the respective external contract:

`const mainnetDAIContract = useExternalContractLoader(mainnetProvider, DAI_ADDRESS, DAI_ABI);`

Change it to:

`const localhostUniswapRouterContract = useExternalContractLoader(localHost, UNIROUTER_ADDRESS, UNIROUTER_ABI);` - this is the hook that is recommended to use to bring in external contracts as the comments say in `App.jsx`

## Will continue with the DAI importing of an external contract, but I think that I will actually start to look at the use of useContractLoader(localProvider) like m00npapi and I were looking at last night.

- useContractLoader() is imported from ./hooks
- This function is then used to load up any external contract passed into it.
- read() and write() functions also are commented out in it, with explanation.

UserProvider --> localProvider means that it will be a burner wallet. Note the below commented out tx variable, this will come in handy later:

` const tx = Transactor(userProvider, gasPrice)`

As you can see within App.jsx, `writeContracts` is already defined. Nice!

You define your external contract as well.

---

## PIVOT on How to Wallet Connect

- We went through the front-end code and components that m00npapi had constructed to get to the point that the scanner component was within our frontend. We pushed that to a forked repo (off of the scaffold-eth-examples meta-multi-sig branch. From there we used git to compare the commit of writing over the example repo that was there from Chris' last commit.) --> most changes are in the App.jsx file.
- We will be going through this line by line to ensure we get the concepts and can write everything up for other people to understand hopefully.

## Notes from sit down with Austin:

- Note: the only way we got it to work was breaking the button when creating the actual scanner button and implementation.
- Optimal is all jumping on our phones and voting from that UI easily.
- Note: when it is a string, the first character is a big thing that says its a string, this is how long it is, and then it gives you all the details so it can be verrrry long.
- We then switched to connecting to something else.
- Something with how the wallet connect is coming into our front end app.

Punkwallet:

- Private key and local storage is how the punkwallet works
- Baby multisig as there is an issue with gnosis?

Questions:

- Why do we have to refresh for Rinkeby to show the updates?
- Some issues happen with DAI whereas it works with WETH.
- When going into the console, and we hit OK, we get invalid parameters... we're not providing a proper address. --> either it's empty or not getting an address.

## NOTES on changes to front-end files for scanning component from scaffold-eth-example repo with meta-multi-sig:

useStaticJsonRPC --> allows you to connect with apps.

_CreateTransaction.jsx_ uncommented lines 56 to 64; just the transferFunds() functions.

- comment out option key

_Owners_ don't worry about it.

_App.jsx_

-

### stuff from the old repo that can likely be ignored (old as in brefore christmas)

Account.jsx:

Line 94 - TransactionDetails added... not sure why lol // maybe delete this later and see what happens

Constants.js:

Alchemy key

Hooks/index.js:

---

[ ] BONUS: multisig as a service! Create a deploy button with a copy paste dialog for sharing so _anyone_ can make a multisig at your url with your frontend // 🙆🏻‍♂️ Answer: Create a front-end component that ties to the `constructor()` of the `MultiSig.sol` contract

[ ] BONUS: testing lol // 🙆🏻‍♂️ Answer: Autograding test file that only covers the main function requirements outlined by this challenge.s

🧪 This build will require a good knowledge of signed messages and you can get a refresher here: https://github.com/scaffold-eth/scaffold-eth-examples/tree/signature-recover

🧫 This build also doubles as a DAO starter kit and it will teach you how to better protect your own funds!

</details>

# Writing the Smart Contracts

This challenge will help you build/understand a mult-sig wallet. This repo is an updated version of the [original tutorial](https://github.com/scaffold-eth/scaffold-eth-examples/blob/meta-multi-sig/README.md) and challenge repos before it. Please read the intro for a background on what we are building first! **This repo has solutions in it for now, but the challenge is to write the smart contracts yourself of course!**

This branch was heavily based off of these resources:

1. [Solidity by Example Multisig](https://solidity-by-example.org/app/multi-sig-wallet/)
2. [Archived Feature Branch meta-multi-sig](https://github.com/scaffold-eth/scaffold-eth-examples/tree/meta-multi-sig)
3. [Archived Feature Branch streaming-multi-sig](https://github.com/scaffold-eth/scaffold-eth-examples/tree/streaming-meta-multi-sig)

---

### **⛳️ Checkpoint 0: 📦 install 📚**

_🚨TODO: Update this with appropriate links once finalized by Austin and team_

```bash
git clone https://github.com/squirtleDevs/scaffold-eth.git challenge-3-simpleDEX
cd challenge-3-simpleDEX
git checkout challenge-3-simpleDEX
yarn install
```

---

### ⛳️ **Checkpoint 1: 🔭 Environment 📺**

You'll have three terminals up for:

`yarn start` (react app frontend)

`yarn chain` (hardhat backend)

`yarn deploy` (to compile, deploy, and publish your contracts to the frontend)

Navigate to the Debug Contracts tab and you should see one smart contracts displayed called `MetaMultiSigWallet`.

> 👩‍💻 Rerun `yarn deploy` whenever you want to deploy new contracts to the frontend (run `yarn deploy --reset` for a completely fresh deploy if you have made no contract changes).

> Below is what your front-end will look like with no implementation code within your smart contracts yet. The buttons will likely break because there are no functions tied to them yet!

TODO: Update photo!

<img src="images/emptyUI.png" width = "800">

> 🎉 You've made it this far in Scaffold-Eth Challenges 👏🏼 . As things get more complex, it might be good to review the design requirements of the challenge first! Check out the empty TemplateMetaMultiSigWallet.sol file to see aspects of each function. If you can explain how each function will work with one another, that's great! 😎

> 🚨 🚨 🦖 **The code blobs within the toggles are some examples of what you can use, but try writing the implementation code for the functions first!**

---

### ⛳️ **Checkpoint 2: Constructor** 👷🏻‍♂️

[ ] TODO: Insert small tid-bit about common patterns seen in solidity smart contracts: arrays with for-loops to populate mappings. \*See my personal notes for this

We want to create an automatic market where our contract will hold reserves of both ETH and 🎈 Balloons. These reserves will provide liquidity that allows anyone to swap between the assets.

Add a couple new variables to `DEX.sol` for `totalLiquidity` and `liquidity`:

<details markdown='1'><summary>👩🏽‍🏫 Solution Code</summary>

```
uint256 public totalLiquidity;
mapping (address => uint256) public liquidity;
```

</details>

These variables track the total liquidity, but also by individual addresses too.
Now, let's create an init() function in `DEX.sol` that is payable and then we can define an amount of tokens that it will transfer to itself.

<details markdown='1'><summary> 👨🏻‍🏫 Solution Code</summary>

```
    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0, "DEX: init - already has liquidity");
        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;
        require(token.transferFrom(msg.sender, address(this), tokens), "DEX: init - transfer did not transact");
        return totalLiquidity;
    }
```

</details>

Calling `init()` will load our contract up with both ETH and 🎈 Balloons.

We can see that the DEX starts empty. We want to be able to call init() to start it off with liquidity, but we don’t have any funds or tokens yet. Add some ETH to your local account using the faucet and then find the `00_deploy_your_contract.js` file. Find and uncomment the line below and add your front-end address:

```
  // // paste in your front-end address here to get 10 balloons on deploy:
  // await balloons.transfer(
  //   "0xe64bAAA0F6012A0F320a262cFe39289bA6cBd0f2",
  //   "" + 10 * 10 ** 18
  // );
```

Run `yarn deploy`. The front end should show you that you have balloon tokens. We can’t just call init() yet because the DEX contract isn’t allowed to transfer tokens from our account. We need to approve() the DEX contract with the Balloons UI.

🤓 Copy and paste the DEX address and then set the amount to 5000000000000000000 (5 _ 10¹⁸). You can confirm this worked using the allowance() function. Now we are ready to call init() on the DEX. We will tell it to take (5 _ 10¹⁸) of our tokens and we will also send 0.01 ETH with the transaction. You can see the DEX contract's value update and you can check the DEX token balance using the balanceOf function on the Balloons UI.

This works pretty well, but it will be a lot easier if we just call the `init()` function as we deploy the contract. In the `00_deploy_your_contract.js` script try uncommenting the init section so our DEX will start with 3 ETH and 3 Balloons of liquidity:

```
    // // uncomment to init DEX on deploy:
  // console.log(
  //   "Approving DEX (" + dex.address + ") to take Balloons from main account..."
  // );
  // // If you are going to the testnet make sure your deployer account has enough ETH
  // await balloons.approve(dex.address, ethers.utils.parseEther("100"));
  // console.log("INIT exchange...");
  // await dex.init(ethers.utils.parseEther("3"), {
  //   value: ethers.utils.parseEther("3"),
  //   gasLimit: 200000,
  // });
```

Now when we `yarn deploy --reset` then our contract should be initialized as soon as it deploys and we should have equal reserves of ETH and tokens.

### 🥅 Goals / Checks

- [ ] 🎈 Under the debug tab, does your DEX show 3 ETH and 3 Balloons of liquidity?

---

### ⛳️ **Checkpoint 3: Price** 🤑

This section is directly from the [original tutorial](https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90) "Price" section. It outlines the general details of the DEX's pricing model.

Now that our contract holds reserves of both ETH and tokens, we want to use a simple formula to determine the exchange rate between the two.
Let’s start with the formula `x * y = k` where `x` and `y` are the reserves:

```
amount of ETH in DEX ) _ ( amount of tokens in DEX ) = k
```

The `k` is called an invariant because it doesn’t change during trades. (The `k` only changes as liquidity is added.) If we plot this formula, we’ll get a curve that looks something like:

<img src="images/yxk.png" width = "300">

> 💡 We are just swapping one asset for another, the “price” is basically how much of the resulting output asset you will get if you put in a certain amount of the input asset.

🤔 OH! A market based on a curve like this will always have liquidity, but as the ratio becomes more and more unbalanced, you will get less and less of the weaker asset from the same trade amount. Again, if the smart contract has too much ETH and not enough tokens, the price to swap tokens to ETH should be more desirable.

When we call `init()` we passed in ETH and tokens at a ratio of 1:1 and that ratio must remain constant. As the reserves of one asset changes, the other asset must also change inversely.

Now, try to edit your DEX.sol smart contract and bring in a this price function!

<details markdown='1'><summary>👩🏽‍🏫 Solution Code</summary>

```

    function price(
        uint256 xInput,
        uint256 xReserves,
        uint256 yReserves
    ) public view returns (uint256 yOutput) {
        uint256 xInputWithFee = xInput.mul(997);
        uint256 numerator = xInputWithFee.mul(yReserves);
        uint256 denominator = (xReserves.mul(1000)).add(xInputWithFee);
        return (numerator / denominator);
    }

```

</details>

We use the ratio of the input vs output reserve to calculate the price to swap either asset for the other. Let’s deploy this and poke around:

```
yarn run deploy
```

Let’s say we have 1 million ETH and 1 million tokens, if we put this into our price formula and ask it the price of 1000 ETH it will be an almost 1:1 ratio:

<img src="images/1.png" width = "300">

If we put in 1000 ETH we will receive 996 tokens. If we’re paying a 0.3% fee it should be 997 if everything was perfect. BUT, there is a tiny bit of slippage as our contract moves away from the original ratio. Let’s dig in more to really understand what is going on here.
Let’s say there is 5 million ETH and only 1 million tokens. Then, we want to put 1000 tokens in. That means we should receive about 5000 ETH:

<img src="images/2.png" width = "300">

Finally, let’s say the ratio is the same but we want to swap 100,000 tokens instead of just 1000. We’ll notice that the amount of slippage is much bigger. Instead of 498,000 back we will only get 453,305 because we are making such a big dent in the reserves.

<img src="images/3.png" width = "300">

💡 The contract automatically adjusts the price as the ratio of reserves shifts away from the equilibrium. It’s called an 🤖 _Automated Market Maker._

### 🥅 Goals / Checks

- [ ] 🤔 Do you understand how the x\*y=k price curve actually works? Write down a clear explanation for yourself and derive the formula for price. You might have to shake off some old algebra skills!
- [ ] 💃 You should be able to go through the price section of this tutorial with the sample numbers and generate the same outputChange variable.

> 💡 _Hints:_ See this [link](https://hackernoon.com/formulas-of-uniswap-a-deep-dive), solve for the change in the Output Reserve. See the section in that link up to the uniswap v3 title.

> 💡💡 _More Hints:_ Also, don't forget to think about how to implement the trading fee. Solidity doesn't allow for decimals, so one way that contracts are written to implement percentage is using whole uints (997 and 1000) as numerator and denominator factors, respectively.

---

### ⛳️ **Checkpoint 4: Trading** 🤝

Let’s edit the DEX.sol smart contract and add two new functions for swapping from each asset to the other, `ethToToken()` and `tokenToEth()`!

<details markdown='1'><summary>👨🏻‍🏫 Solution Code </summary>

```
    /**
     * @notice sends Ether to DEX in exchange for $BAL
     */
    function ethToToken() public payable returns (uint256 tokenOutput) {
        uint256 ethReserve = address(this).balance.sub(msg.value);
        uint256 token_reserve = token.balanceOf(address(this));
        uint256 tokenOutput = price(msg.value, ethReserve, token_reserve);
        require(token.transfer(msg.sender, tokenOutput), "ethToToken(): reverted swap.");
        return tokenOutput;
        emit EthToTokenSwap(msg.sender, tokenOutput, msg.value);
    }

    /**
     * @notice sends $BAL tokens to DEX in exchange for Ether
     */
    function tokenToEth(uint256 tokenInput) public returns (uint256 ethOutput) {
        uint256 token_reserve = token.balanceOf(address(this));
        uint256 ethOutput = price(tokenInput, token_reserve, address(this).balance);
        require(token.transferFrom(msg.sender, address(this), tokenInput), "tokenToEth(): reverted swap.");
        (bool sent, ) = msg.sender.call{ value: ethOutput }("");
        require(sent, "tokenToEth: revert in transferring eth to you!");
        return ethOutput;
        emit TokenToEthSwap(msg.sender, ethOutput, tokenInput);
    }
```

</details>

> 💡 Each of these functions calculate the resulting amount of output asset using our price function that looks at the ratio of the reserves vs the input asset. We can call tokenToEth and it will take our tokens and send us ETH or we can call ethToToken with some ETH in the transaction and it will send us tokens. Deploy it and try it out!

---

### ⛳️ **Checkpoint 5: Liquidity** 🌊

So far, only the init() function controls liquidity. To make this more decentralized, it would be better if anyone could add to the liquidity pool by sending the DEX both ETH and tokens at the correct ratio.

Let’s create two new functions that let us deposit and withdraw liquidity. How would you write this function out? Try before taking a peak!

> 💡 _Hints:_
> The deposit() function receives ETH and also transfers tokens from the caller to the contract at the right ratio. The contract also tracks the amount of liquidity the depositing address owns vs the totalLiquidity.
> The withdraw() function lets a user take both ETH and tokens out at the correct ratio. The actual amount of ETH and tokens a liquidity provider withdraws will be higher than what they deposited because of the 0.3% fees collected from each trade. This incentivizes third parties to provide liquidity.

<details markdown='1'><summary>👩🏽‍🏫 Solution Code </summary>

```
/**
     * @notice allows deposits of $BAL and $ETH to liquidity pool
     * NOTE: Ratio needs to be maintained.
     */
    function deposit() public payable returns (uint256 tokensDeposited) {
        uint256 ethReserve = address(this).balance.sub(msg.value);
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 tokenDeposit;

        tokenDeposit = msg.value.mul((tokenReserve / ethReserve)).add(1);
        uint256 liquidityMinted = msg.value.mul(totalLiquidity / ethReserve);
        liquidity[msg.sender] = liquidity[msg.sender].add(liquidityMinted);
        totalLiquidity = totalLiquidity.add(liquidityMinted);

        require(token.transferFrom(msg.sender, address(this), tokenDeposit));
        return tokenDeposit;
    }

    /**
     * @notice allows withdrawal of $BAL and $ETH from liquidity pool
     */
    function withdraw(uint256 amount) public returns (uint256 eth_amount, uint256 token_amount) {
        uint256 ethReserve = address(this).balance;
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 ethWithdrawn;

        ethWithdrawn = amount.mul((ethReserve / totalLiquidity));

        uint256 tokenAmount = amount.mul(tokenReserve) / totalLiquidity;
        liquidity[msg.sender] = liquidity[msg.sender].sub(ethWithdrawn);
        totalLiquidity = totalLiquidity.sub(ethWithdrawn);
        (bool sent, ) = msg.sender.call{ value: ethWithdrawn }("");
        require(sent, "withdraw(): revert in transferring eth to you!");
        require(token.transfer(msg.sender, tokenAmount));

        return (ethWithdrawn, tokenAmount);
    }

```

 </details>

🚨 Take a second to understand what these functions are doing if you pasted them into DEX.sol in packages/hardhat/contracts:

### 🥅 Goals / Checks

- [ ] 💧 Deposit liquidity, and then check your liquidity amount through the mapping in the debug tab. Has it changed properly? Did the right amount of assets get deposited?
- [ ] 🧐 What happens if you deposit(), then another user starts swapping out for most of the balloons, and then you try to withdraw your position as a liquidity provider? Answer: you should get the amount of liquidity proportional to the ratio of assets within the isolated liquidity pool.

---

### ⛳️ **Checkpoint 6: UI** 🖼

Cool beans! Your front-end should be showing something like this now!

<img src="images/ui-screenshot-final.png" width = "700">

Now, a user can just enter the amount of ETH or tokens they want to swap and the chart will display how the price is calculated. The user can also visualize how larger swaps result in more slippage and less output asset.

💸 A user can also deposit and withdraw from the liquidity pool, earning fees

### 🚨TODO: STEVE - ARCHIVE THIS TOGGLE SECTION AS PER TO DO LIST AT TOP OF THIS DOCUMENT

<details markdown='1'><summary> 🚨 If you're using the master branch, and not the DEX challenge feature branch, then click this toggle to see how to hook things up for your front end. 🚨 </summary>

**NOTE: THIS IS IF THE USER IS GOING OFF OF THE MASTER BRANCH... ALTHOUGH WHEN THEY READ THIS I'M GUESSING THAT THEY ARE USING OUR REPO WHICH WILL HAVE THE STUFF ALL READY TO GO, THEY JUST GOTTA UNCOMMENT OR WHATEVER**

NOTE: <details markdown='1'><summary>Context for people newer to ReactJS</summary> For those that are really new to anything front-end development, there are many resources out there to possibly use. This one was particularly helpful from minutes 15 to 20 describing the typical folder structure within a ReactJS project.
https://www.youtube.com/watch?v=w7ejDZ8SWv8&ab_channel=TraversyMedia

 </details>

NOTE:
\*From a fresh master branch off of scaffold-eth repo, we found the following was needed to get things hooked up with the front-end:

1. Update index.js file within components sub-directory to include some things from the OG challenge repos:

```
export { default as Dex } from "./DEX";
export { default as Curve } from "./Curve";
```

2. Other files you'll need from OG repo: DEX.jsx, Curve.jsx
   NOTE: INSERT LINKS TO OG REPO

3. You will likely run into errors from your front-end assuming you've ran `yarn start` already. Let's fix those!

Find useEventListener, useContractLoader, useContractReader, useBlockNumber, useBlanace, useTokenBalance within DEX.jsx file. You will see them calling for .hooks --> delete those and replace with the following:

```
import { useEventListener } from "eth-hooks/events/useEventListener";
import { useContractLoader } from "eth-hooks";
import { useContractReader } from "eth-hooks";
import { useBlockNumber } from "eth-hooks";
import { useBalance } from "eth-hooks";
import { useTokenBalance } from "eth-hooks/erc/erc-20/useTokenBalance";
```

These replacements are needed because the pointers within the `DEX.jsx` and `Curve.jsx` files from the OG repo are not accurate with the `master branch` off of `scaffold-eth` repo.

In 00_deploy_your_contracts.js, you'll have to write in the necessary code to get your contracts, using Ethers.js.

As well, make sure that the tags are updated to your contract names, it should be something like `module.exports.tags = ["YourContract"];` and you'll want to change it to:

`module.exports.tags = ["Balloons", "DEX"];`

**Further Check-Ups between DEX in Ch-3 and Ch-5**

NOTE: CLEAN THIS DOC UP

What's in Ch-5 but not Ch-3
_Imports_
Blockies
Missing Button and List
DownloadOutlined and UploadOutlined

```
import { Card, Col, Divider, Input, Row } from "antd"; 😎
import { useBalance, useContractReader, useBlockNumber } from "eth-hooks"; 😎
.
.
.
importing Address, TokenBalance are coming from their respectively named subdirectories: "./Address;," and "./TokenBalance;" 😎
.
.
.
export default function DEX(props) {etc.} <-- this line may have the wrong name, be careful because you are likely exporting Dex, not DEX. --> challnege 3 has Dex, ch5 has DEX
.
.
.
  const ethBalance = useBalance(contractAddress, props.localProvider);
😭 breaks challenge 3 code!
.
const tx = Transactor(props.injectedProvider...) is different than challenge 3 set up for const tx... in ch3 it is set up so we do not use injectedProvider 😎
.
.
.
const contractAddress = ternary operators in challenge5, whereas in challenge3 it is just direct, no ternary.
.
.
.
const tokenBalance = useTokenBalance --> this is different but we think it isn't breaking changes.
.
.
.
nonce is in challenge 5 and not challenge 3.
.
.
let swapTx differs just cause of nonce showing up.
.
.
consolelogging extras
.
.
let addingEth = 0 is in challenge 5.
.
.
Balloons button is in Challenge 3 DEX not Challenge 5 DEX

```

### Front-End (without the debug tab)

So the debug tab was taken care, or should be working now if all pointers have been corrected and variables instantiated, respectively.

The front-end is brought in through several steps.

State the aspects within the actual front-end display. First, find the comment in your `App.jsx`:
`{/* pass in any web3 props to this Home component. For example, yourLocalBalance */}`

There you will see the debug code blob below it, it is here where you will outline details for your home-page. Follow the medium blog post and you will see two inputs to bring into your `App.jsx` file:

**NOTE: NOTE TO SELF TO FIX THIS PART AS I'M NOT GETTING THE DEX TO LOAD ON THE FRONT END! ONLY BALLOONS :(**

```
<DEX
  address={address}
  injectedProvider={injectedProvider}
  localProvider={localProvider}
  mainnetProvider={mainnetProvider}
  readContracts={readContracts}
  price={price}
/>

<Contract
  title={"🎈 Balloons"}
  name={"Balloons"}
  show={["balanceOf","approve"]}
  provider={localProvider}
  address={address}
/>
```

Your front-end should now load accordingly!

</details>

---

### **Checkpoint 7: 💾 Deploy it!** 🛰

📡 Edit the `defaultNetwork` in `packages/hardhat/hardhat.config.js`, as well as `targetNetwork` in `packages/react-app/src/App.jsx`, to [your choice of public EVM networks](https://ethereum.org/en/developers/docs/networks/)

## 🔶 Infura

> You will need to get a key from infura.io and paste it into constants.js in packages/react-app/src:

![nft13](https://user-images.githubusercontent.com/526558/124387174-d83c0180-dcb3-11eb-989e-d58ba15d26db.png)

👩‍🚀 You will want to run `yarn account` to see if you have a **deployer address**

🔐 If you don't have one, run `yarn generate` to create a mnemonic and save it locally for deploying.

🛰 Use an [instantwallet.io](https://instantwallet.io) to fund your **deployer address** (run `yarn account` again to view balances)

> 🚀 Run `yarn deploy` to deploy to your public network of choice (😅 wherever you can get ⛽️ gas)

🔬 Inspect the block explorer for the network you deployed to... make sure your contract is there.

👮 Your token contract source needs to be **verified**... (source code publicly available on the block explorer)

---

### **Checkpoint 8: 📜 Contract Verification**

Update the api-key in packages/hardhat/package.json file. You can get your key [here](https://etherscan.io/myapikey).

![Screen Shot 2021-11-30 at 10 21 01 AM](https://user-images.githubusercontent.com/9419140/144075208-c50b70aa-345f-4e36-81d6-becaa5f74857.png)

> Now you are ready to run the `yarn verify --network your_network` command to verify your contracts on etherscan 🛰

This will be the URL you submit to [SpeedRun](https://speedrunethereum.com).

---

### **Checkpoint 9: 🚢 Ship it! 🚁**

📦 Run `yarn build` to package up your frontend.

💽 Upload your app to surge with `yarn surge` (you could also `yarn s3` or maybe even `yarn ipfs`?)

🚔 Traffic to your url might break the [Infura](https://infura.io/) rate limit, edit your key: `constants.js` in `packages/ract-app/src`.

---

> 💬 Problems, questions, comments on the stack? Post them to the [🏗 scaffold-eth developers chat](https://t.me/joinchat/F7nCRK3kI93PoCOk)

# 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨

---

# 🏃‍♀️ Quick Start

required: [Node](https://nodejs.org/dist/latest-v12.x/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

```bash
git clone https://github.com/scaffold-eth/scaffold-eth-examples meta-multi-sig

cd meta-multi-sig

git checkout meta-multi-sig
```

```bash

yarn install

```

```bash

yarn start

```

> in a second terminal window:

```bash
cd scaffold-eth
yarn chain

```

🔏 Edit your smart contract `MetaMultiSigWallet.sol` in `packages/hardhat/contracts`

📝 Edit your frontend `App.jsx` in `packages/react-app/src`

💼 Edit your deployment script `deploy.js` in `packages/hardhat/scripts`

📱 Open http://localhost:3000 to see the app

> in a third terminal window:

```bash
yarn backend

```

🔧 Configure your deployment in `packages/hardhat/scripts/deploy.js`

> Edit the chainid, your owner addresses, and the number of signatures required:

![image](https://user-images.githubusercontent.com/2653167/99156751-bfc59b00-2680-11eb-8d9d-e33777173209.png)

> in a fourth terminal deploy with your frontend address as one of the owners:

```bash

yarn deploy

```

> Use the faucet wallet to send your multi-sig contract some funds:

![image](https://user-images.githubusercontent.com/31567169/118389510-53315600-b63b-11eb-9daf-f0aaa479a23e.png)

> To add new owners, use the "Owners" tab:

![image](https://user-images.githubusercontent.com/31567169/118389556-896ed580-b63b-11eb-8ed6-c1e690778c8e.png)

This will take you to a populated transaction create page:

![image](https://user-images.githubusercontent.com/31567169/118389576-9986b500-b63b-11eb-8411-c227b148992a.png)

> Create & sign the new transaction:

![image](https://user-images.githubusercontent.com/31567169/118389603-ae634880-b63b-11eb-968f-ca78c2456ddb.png)

You will see the new transaction in the pool (this is all off-chain):

![image](https://user-images.githubusercontent.com/31567169/118389616-bd49fb00-b63b-11eb-82f7-f65ca2ee7e80.png)

Click on the ellipsses button [...] to read the details of the transaction

![image](https://user-images.githubusercontent.com/31567169/118389642-d6eb4280-b63b-11eb-9676-da7e7afc5614.png)

> Give your account some gas at the faucet and execute the transaction

The transction will appear as "executed" on the front page:

![image](https://user-images.githubusercontent.com/31567169/118389655-e8cce580-b63b-11eb-8428-913c6f39e48f.png)

> Create a transaction to send some funds to your frontend account:

![image](https://user-images.githubusercontent.com/31567169/118389693-0ef28580-b63c-11eb-95d9-c5f397bf5972.png)

This time we will need a second signature:

![image](https://user-images.githubusercontent.com/31567169/118389716-3cd7ca00-b63c-11eb-959e-d46ffe31e62e.png)

> Sign the transacton with enough owners:
> ![image](https://user-images.githubusercontent.com/31567169/118389773-90e2ae80-b63c-11eb-9658-e9c411542f33.png)

(You'll notice you don't need ⛽️gas to sign transactions.)

> Execute the transction to transfer the funds:

![image](https://user-images.githubusercontent.com/31567169/118389808-bff92000-b63c-11eb-9107-9af5b77d4e20.png)

(You might need to trigger a new block by sending yourself some faucet funds or something. HartHat blocks only get mined when there is a transaction.)

💼 Edit your deployment script `deploy.js` in `packages/hardhat/scripts`

🔏 Edit your contracts form, `MetaMultiSigWallet.sol` in `packages/hardhat/contracts`

📝 Edit your frontend in `packages/react-app/src/views`

## ⚔️ Side Quests

#### 🐟 Create custom signer roles for your Wallet

You may not want every signer to create new transfers, only allow them to sign existing transactions or a mega-admin role who will be able to veto any transaction.

#### 😎 Integrate this MultiSig wallet into other branches like nifty-ink

Make a MultiSig wallet to store your precious doodle-NFTs!?

---

## 📡 Deploy the wallet!

🛰 Ready to deploy to a testnet?

> Change the `defaultNetwork` in `packages/hardhat/hardhat.config.js`

![image](https://user-images.githubusercontent.com/2653167/109538427-4d38c980-7a7d-11eb-878b-b59b6d316014.png)

🔐 Generate a deploy account with `yarn generate`

![image](https://user-images.githubusercontent.com/2653167/109537873-a2c0a680-7a7c-11eb-95de-729dbf3399a3.png)

👛 View your deployer address using `yarn account` (You'll need to fund this account. Hint: use an [instant wallet](https://instantwallet.io) to fund your account via QR code)

![image](https://user-images.githubusercontent.com/2653167/109537339-ff6f9180-7a7b-11eb-85b0-46cd72311d12.png)

👨‍🎤 Deploy your wallet:

```bash
yarn deploy
```

---

> ✏️ Edit your frontend `App.jsx` in `packages/react-app/src` to change the `targetNetwork` to wherever you deployed your contract:

![image](https://user-images.githubusercontent.com/2653167/109539175-3e9ee200-7a7e-11eb-8d26-3b107a276461.png)

You should see the correct network in the frontend:

![image](https://user-images.githubusercontent.com/2653167/109539305-655d1880-7a7e-11eb-9385-c169645dc2b5.png)

> Also change the poolServerUrl constant to your deployed backend (via yarn backend)

![image](https://user-images.githubusercontent.com/31567169/116589184-6f3fb280-a92d-11eb-8fff-d1e32b8359ff.png)

Alternatively you can use the pool server url in the above screenshot

---

#### 🔶 Infura

> You will need to get a key from [infura.io](https://infura.io) and paste it into `constants.js` in `packages/react-app/src`:

![image](https://user-images.githubusercontent.com/2653167/109541146-b5d57580-7a80-11eb-9f9e-04ea33f5f45a.png)

---

## 🛳 Ship the app!

> ⚙️ build and upload your frontend and share the url with your friends...

```bash

# build it:

yarn build

# upload it:

yarn surge

OR

yarn s3

OR

yarn ipfs
```

![image](https://user-images.githubusercontent.com/2653167/109540985-7575f780-7a80-11eb-9ebd-39079cc2eb55.png)

> 👩‍❤️‍👨 Share your public url with friends, add signers and send some tasty ETH to a few lucky ones 😉!!
