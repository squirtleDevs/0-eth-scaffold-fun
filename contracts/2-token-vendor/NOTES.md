# General Notes on Challenge

### Problems I am working on or experienced:

> 1. REPLACEMENT_UNDERPRICED --> this error comes up when I attempt to deploy to rinkeby and goerli testnets so far. Those are the only ones I have tried
>    A snippit of the error can be seen below:

> `deploying "Vendor"replacement fee too low (error={"name":"ProviderError","code":-32000,"\_isProviderError":true}, method="sendTransaction", transaction=undefined, code=REPLACEMENT_UNDERPRICED, version=providers/5.4.4) {"reason":"replacement fee too low","code":"REPLACEMENT_UNDERPRICED","error":{"name":"ProviderError","code":-32000,"\_isProviderError":true},"method":"sendTransaction"} Error: replacement fee too low (error={"name":"ProviderError","code":-32000,"\_isProviderError":true}, method="sendTransaction", transaction=undefined, code=REPLACEMENT_UNDERPRICED, version=providers/5.4.4)`

> Possible remedies attempted:

> ref: https://docs.ethers.io/v5/single-page/
> ref: https://ethereum.stackexchange.com/questions/27256/error-replacement-transaction-underpriced/44875
>
> 1. Increasing gas price for the respective networks. Although when I tried goerli I had not even deployed anything yet through it, so not sure where the pre-existing tx with the same nonce that it is trying to replace is. Also note that the localhost works, but that is because it works with the local hardhat node. Hmm maybe I messed up with the setup having have a specific contract be the deployer...? Anyways, I'll revisit this after I work on other stuff. --> What I am referring to is the instructions where it outlines to transfer the total GLD to the vendor - see my notes in the README.md for this project.
> 2. Seeing if I can change the nonce, but I am not sure where to do that explicitly. `hardhat.config.js` looks like a good place to start but not sure.

---
