# 🙅🏻‍♂️ 🚧 General public ignore below, these are just notes for devs to fix about this challenge!

### 🚨 STEVE/M00NPAPI/WHOEVER TODO: Aspects to Check Before Finalizing

<details markdown='1'><summary>👨🏻‍🏫 TO DO List</summary>

1. Front End looks like it is being mainly derived from DEX.jsx (which was taken from an old repo - challenge-3-dex from scaffold eth repo). We simply connected and routed what was needed and it started to work. Since it is importing from there, my guess is that when the smart contracts are blank, it will display the front end (buttons and all). If you click on a button that you know doesn't line up with a function from the smart contracts, then an error will arise in your webpage. **Could be worthwhile to do a better deep dive into front-end with someone who knows front-end** This may be why it is a bit clunky too!

2. The liquidity mapping is not displaying properly in debug or the front end for some reason. It was working before we started working on the front end. See this line of code. I'm guessing that if it was removed, that the liquidity may start to display right at least in the debug tab. The odd thing is that sometimes it works, and other times it does not.

```
<Divider> Liquidity ({liquidity ? ethers.utils.formatEther(liquidity) : "none"}):</Divider>
```

3. Archive the rough notes (unfinished) for those who are tackling this project from the Master branch itself. This is messy and unorganized because I took down notes as m00npapi and I progressed but only passively. After I get more experience with front end I think I can write this better.

Extra UI TODO's

4. When you swap from tokens to eth it automatically pops up the swap, we probably either want that popup to come a few seconds after the approve (you have to craft the transactions manually and have them sign the raw transaction with the next nonce) OR maybe a second button for the second action.
5. Display how much liquidity I have am providing / how much locked up I have of each asset or something
6. Formalize document and repo for an official challenge for scaffold-eth community / program

DEX.test.js TODO:

7. See TODO: in DEX.test.js

</details>

---

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
