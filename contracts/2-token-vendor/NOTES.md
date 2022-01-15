# General Notes on Challenge

I am currently stuck on a bug that I was not able to get remedies for from the telegram (yet). So I figured sharing this github repo link showing this explanation and my contract files (under sub-directory a-final-submission) would be okay for now at least until I can get it deployed onto a network (past this error!). Please see my below notes for this project and the error itself. Any comments and feedback are welcome!

### Problems I am working on or experienced:

1. REPLACEMENT_UNDERPRICED --> this error comes up when I attempt to deploy to rinkeby and goerli testnets so far. Those are the only ones I have tried

   A snippit of the error can be seen below:

   ```
   deploying "Vendor"replacement fee too low (error={"name":"ProviderError","code":-32000,"\_isProviderError":true}, method="sendTransaction", transaction=undefined, code=REPLACEMENT_UNDERPRICED, version=providers/5.4.4) {"reason":"replacement fee too low","code":"REPLACEMENT_UNDERPRICED","error":{"name":"ProviderError","code":-32000,"\_isProviderError":true},"method":"sendTransaction"} Error: replacement fee too low (error={"name":"ProviderError","code":-32000,"\_isProviderError":true}, method="sendTransaction", transaction=undefined, code=REPLACEMENT_UNDERPRICED, version=providers/5.4.4)
   ```

   Possible remedies attempted:

   ref: https://docs.ethers.io/v5/single-page/
   ref: https://ethereum.stackexchange.com/questions/27256/error-replacement-transaction-underpriced/44875

   > 1. Increasing gas price for the respective networks. Although when I tried goerli I had not even deployed anything yet through it, so not sure where the pre-existing tx with the same nonce that it is trying to replace is. Also note that the localhost works, but that is because it works with the local hardhat node. Hmm maybe I messed up with the setup having have a specific contract be the deployer...? --> The point in the challenge that this error comes up: when it states to transfer the total GLD to the vendor - see my notes in the README.md for this project.
   > 2. Seeing if I can change the nonce, but I am not sure where to do that explicitly. `hardhat.config.js` looks like a good place to start but not sure.
