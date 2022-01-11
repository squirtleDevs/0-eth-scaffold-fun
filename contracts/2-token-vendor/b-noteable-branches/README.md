# 🏗 scaffold-eth | 🏰 BuidlGuidl

## 🚩 Challenge 2: 🏵 Token Vendor 🤖

> 🤖 Smart contracts are kind of like "always on" _vending machines_ that **anyone** can access. Let's make a decentralized, digital currency. Then, let's build an unstoppable vending machine that will buy and sell the currency. We'll learn about the "approve" pattern for ERC20s and how contract to contract interactions work.

> 🏵 Create `YourToken.sol` smart contract that inherits the **ERC20** token standard from OpenZeppelin. Set your token to `_mint()` **1000** (\* 10 \*\* 18) tokens to the `msg.sender`. Then create a `Vendor.sol` contract that sells your token using a payable `buyTokens()` function.

> 🎛 Edit the frontend that invites the user to `<input\>` an amount of tokens they want to buy. We'll display a preview of the amount of ETH (or USD) it will cost with a confirm button.

> 🔍 It will be important to verify your token's source code in the block explorer after you deploy. Supporters will want to be sure that it has a fixed supply and you can't just mint more.

> 🏆 The final **deliverable** is an app that lets users purchase and transfer your token. Deploy your contracts on your public chain of choice and then `yarn build` and `yarn surge` your app to a public web server. Share the url in the [Challenge 2 telegram channel](https://t.me/joinchat/IfARhZFc5bfPwpjq).🍾

🧫 Everything starts by ✏️ Editing `YourToken.sol` in `packages/hardhat/contracts`

---

### Checkpoint 0: 📦 install 📚

```bash
git clone https://github.com/scaffold-eth/scaffold-eth-challenges challenge-2-token-vendor
cd challenge-2-token-vendor
git checkout challenge-2-token-vendor
yarn install
```

🔏 Edit your smart contract `YourToken.sol` in `packages/hardhat/contracts`

---

### Checkpoint 1: 🔭 Environment 📺

You'll have three terminals up for:

`yarn chain` (hardhat backend)

`yarn start` (react app frontend)

`yarn deploy` (to compile, deploy, and publish your contracts to the frontend)

> 👀 Visit your frontend at http://localhost:3000

> 👩‍💻 Rerun `yarn deploy --reset` whenever you want to deploy new contracts to the frontend.

> ignore any warnings, we'll get to that...

---

### Checkpoint 2: 🏵Your Token 💵

> 👩‍💻 Edit `YourToken.sol` to inherit the **ERC20** token standard from OpenZeppelin

Mint **1000** (\* 10 \*\* 18) in the constructor (to the `msg.sender`) and then send them to your frontend address in the `deploy/00_deploy_your_token.js`:

```javascript
const result = await yourToken.transfer("**YOUR FRONTEND ADDRESS**", ethers.utils.parseEther("1000"));
```

**SP - NOTE: You will also have to uncomment and align the arguments for the deploy script.**

(Your frontend address is the address in the top right of your frontend. Go to localhost:3000 and copy the address from the top right.)

#### 🥅 Goals

- [x] Can you check the `balanceOf()` your frontend address in the **YourToken** of the `Debug Contracts` tab? ANSWER: YES
- [x] Can you `transfer()` your token to another account and check _that_ account's `balanceOf`? ANSWER: YES

(Use an incognito window to create a new address and try sending to that new address. Use the `transfer()` function in the `Debug Contracts` tab.)

---

### Checkpoint 3: ⚖️ Vendor 🤖

> 👩‍💻 Edit the `Vendor.sol` contract with a **payable** `buyTokens()` function

Use a price variable named `tokensPerEth` set to **100**:

```solidity
uint256 public constant tokensPerEth = 100;
```

> 📝 The `buyTokens()` function in `Vendor.sol` should use `msg.value` and `tokensPerEth` to calculate an amount of tokens to `yourToken.transfer()` to `msg.sender`.

> 📟 Emit **event** `BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens)` when tokens are purchased.

Edit `deploy/01_deploy_vendor.js` to deploy the `Vendor` (uncomment Vendor deploy lines).

You will also want to change `00_deploy_your_token.js` and `01_deploy_vendor.js` so you transfer the tokens to the `vendor.address` instead of your frontend address.
**SP - NOTE: I ran into errors here as the scripts require that the YourToken.sol contract is deployed first, then uses that address as an argument for the Vendor.sol constructor. Changing the recepient of the initial transfer of minted GLD to Vendor.sol cannot happen due to the circularity of the proposed process. Instead what ended up working for me is to send the initial mint amount to `deployer` within the `result` function in `00_deploy_your_token.js` and from there carry out the `transferTransaction` within `01_deploy_vendor.js`.**

```js
const result = await yourToken.transfer(vendor.address, ethers.utils.parseEther("1000"));
```

(You will use the `YourToken` UI tab and the frontend for most of your testing. Most of the UI is already built for you for this challenge.)

> 📝 Edit `Vendor.sol` to inherit _Ownable_.

In `deploy/01_deploy_vendor.js` you will need to call `transferOwnership()` on the `Vendor` to make _your frontend address_ the `owner`:

```js
await vendor.transferOwnership("**YOUR FRONTEND ADDRESS**");
```

> 📝 Finally, add a `withdraw()` function in `Vendor.sol` that lets the owner withdraw ETH from the vendor.

#### 🥅 Goals

- [x] Does the `Vendor` address start with a `balanceOf` **1000** in `YourToken` on the `Debug Contracts` tab?
- [x] Can you buy **10** tokens for **0.1** ETH?
- [x] Can you transfer tokens to a different account?
- [x] Can the `owner` withdraw the ETH from the `Vendor`?

#### ⚔️ Side Quests

- [x] Can _anyone_ withdraw? Test _everything_! ANSWER: Anyone means: attempt to withdraw from folks who aren't owner. Random burner accounts, the YourToken contract address, the vendor address. The withdraw() function checks who the msg.sender is and whether it is owner or not. So testing with other burners is really all you can do easily.
- [x] What if you minted **2000** and only sent **1000** to the `Vendor`? ANSWER: I think that you'd just have an extra 1000 minted tokens sitting in the YourToken.sol contract, of which can be minted freely by anyone as it follows typical erc20 standards. Oh actually, they are minted and just stuck in the contract it seems. You would need a way to rescue your tokens (as seen in Yearn contracts and whatnot I think).

---

### Checkpoint 4: 🤔 Vendor Buyback 🤯

👩‍🏫 The hardest part of this challenge is to build your `Vendor` to buy the tokens back.

🧐 The reason why this is hard is the `approve()` pattern in ERC20s.

😕 First, the user has to call `approve()` on the `YourToken` contract, approving the `Vendor` contract address to take some amount of tokens.

🤨 Then, the user makes a _second transaction_ to the `Vendor` contract to `sellTokens()`.

🤓 The `Vendor` should call `yourToken.transferFrom(msg.sender, address(this), theAmount)` and if the user has approved the `Vendor` correctly, tokens should transfer to the `Vendor` and ETH should be sent to the user.

(Use the `Debug Contracts` tab to call the approve and sellTokens() at first but then look in the `App.jsx` for the extra approve/sell UI to uncomment.)

#### 🥅 Goal

- [x] Can you sell tokens back to the vendor and receive ETH?

#### ⚔️ Side Quest

- [ ] Should we disable the `owner` withdraw to keep liquidity in the `Vendor`?
- [ ] It would be a good idea to display Sell Token Events. Create the `event` and `emit` in your `Vendor.sol` and look at `buyTokensEvents` in your `App.jsx` for an example of how to update your frontend.

---

### Checkpoint 5: 💾 Deploy it! 🛰

📡 Edit the `defaultNetwork` in `packages/hardhat/hardhat.config.js`, as well as `targetNetwork` in `packages/react-app/src/App.jsx`, to [your choice of public EVM networks](https://ethereum.org/en/developers/docs/networks/)

👩‍🚀 You will want to run `yarn account` to see if you have a **deployer address**.

🔐 If you don't have one, run `yarn generate` to create a mnemonic and save it locally for deploying.

🛰 Use a faucet like [faucet.paradigm.xyz](https://faucet.paradigm.xyz/) to fund your **deployer address** (run `yarn account` again to view balances)

> 🚀 Run `yarn deploy` to deploy to your public network of choice (😅 wherever you can get ⛽️ gas)

🔬 Inspect the block explorer for the network you deployed to... make sure your contract is there.

---

### Checkpoint 6: 🚢 Ship it! 🚁

📦 Run `yarn build` to package up your frontend.

💽 Upload your app to surge with `yarn surge` (you could also `yarn s3` or maybe even `yarn ipfs`?)

🚔 Traffic to your url might break the [Infura](https://infura.io/) rate limit, edit your key: `constants.js` in `packages/ract-app/src`.

🎖 Show off your app by pasting the url in the [Challenge 2 telegram channel](https://t.me/joinchat/IfARhZFc5bfPwpjq) 🎖

---

### Checkpoint 7: 📜 Contract Verification

Update the api-key in packages/hardhat/package.json file. You can get your key [here](https://etherscan.io/myapikey).

![Screen Shot 2021-11-30 at 10 21 01 AM](https://user-images.githubusercontent.com/9419140/144075208-c50b70aa-345f-4e36-81d6-becaa5f74857.png)

> Now you are ready to run the `yarn verify --network your_network` command to verify your contracts on etherscan 🛰

This will be the URL you submit to [SpeedRun](https://speedrunethereum.com).

---

> 🏃 Head to your next challenge [here](https://speedrunethereum.com).

> 💬 Problems, questions, comments on the stack? Post them to the [🏗 scaffold-eth developers chat](https://t.me/joinchat/F7nCRK3kI93PoCOk)
